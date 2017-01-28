using System;
using System.Text.RegularExpressions;
using System.Web.UI;
using Microsoft.SharePoint;
using Microsoft.SharePoint.Administration;
using Microsoft.SharePoint.Utilities;
using LukeSkywalker.IPNetwork;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using Microsoft.SharePoint.IdentityModel.Pages;

namespace OrbitOne.SharePoint.Claims.SignIn
{
    public class AutoSignin : MultiLogonPage
    {
        protected override void OnLoad(EventArgs e)
        {
            if (!IsPostBack)
            {
                if (SPContext.Current == null) return;
                if (SPContext.Current.Site == null) return;
                if (SPContext.Current.Site.WebApplication == null) return;

                SPWebApplication app = SPContext.Current.Site.WebApplication;

                SignInConfiguration config = app.GetChild<SignInConfiguration>("SignInConfig");
                if (config == null)
                    throw new NullReferenceException("Config was not found");

                SPAlternateUrl u = app.AlternateUrls[Request.Url];
                if (u == null)
                    throw new NullReferenceException("Could not find " + Request.Url + " in alternate URLs");
                SPUrlZone zone = u.UrlZone;

                string components = Request.Url.GetComponents(UriComponents.Query, UriFormat.SafeUnescaped);

                if (!app.IisSettings.ContainsKey(zone))
                    zone = SPUrlZone.Default;
                    //throw new KeyNotFoundException("IIS settings did not have zone " + zone);
                SPIisSettings settings = app.IisSettings[zone];
                bool isMappingFound = false;

                IPAddress ipv4 = IpNetworking.GetIP4Address();
                string targetProvider;
                try
                {
                    KeyValuePair<IPNetwork, string> providerMapping = config.ProviderMappings
                        .Select(kvp => new KeyValuePair<IPNetwork, string>(IPNetwork.Parse(kvp.Key), kvp.Value))
                        .Where(x => IPNetwork.Contains(x.Key, ipv4))
                        .OrderBy(x => x.Key.Cidr)
                        .Last();
                    isMappingFound = true;
                    targetProvider = providerMapping.Value;
                }
                catch
                {
                    isMappingFound = false;
                    targetProvider = null;
                }
                var signinPageMappings = config.SingInPageMappings;
                if (config != null && isMappingFound)
                {
                    foreach (SPAuthenticationProvider provider in settings.ClaimsAuthenticationProviders)
                    {
                        if (string.Compare(provider.DisplayName, targetProvider, true, System.Globalization.CultureInfo.CurrentUICulture) == 0
                            || string.Compare(provider.ClaimProviderName, targetProvider, true, System.Globalization.CultureInfo.CurrentUICulture) == 0)
                        {
                            string url = provider.AuthenticationRedirectionUrl.ToString();
                            if (signinPageMappings.ContainsKey(provider.DisplayName))
                            {
                                url = signinPageMappings[provider.DisplayName];
                            }

                            if (provider is SPWindowsAuthenticationProvider)
                            {
                                components = EnsureReturnUrl(components);
                            }

                            SPUtility.Redirect(url, SPRedirectFlags.Default, this.Context, components);
                        }
                    }
                    base.OnLoad(e);
                }
                else
                {
                    string loginPage = string.Empty;
                    if (signinPageMappings.ContainsKey("default"))
                    {
                        loginPage = signinPageMappings["default"];
                    }
                    if (!string.IsNullOrEmpty(loginPage))
                    {
                        SPUtility.Redirect(loginPage, SPRedirectFlags.Default, this.Context, components);
                        base.OnLoad(e);
                    }
                }
            }
        }
        private string EnsureReturnUrl(string queryString)
        {
            if(string.IsNullOrEmpty(queryString))
            {
                queryString = "?";
            }
            if (!queryString.Contains("ReturnUrl="))
            {
                if (!string.IsNullOrEmpty(queryString))
                {
                    queryString = queryString + "&";
                }
                queryString = queryString + "ReturnUrl=/";
            }
            
            return queryString;
        }
    }
}