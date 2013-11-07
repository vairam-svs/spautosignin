using System;
using System.Net;
using System.Web;

namespace OrbitOne.SharePoint.Claims.SignIn
{
    public class IpNetworking
    {
        public static string GetIP4AddressAsString()
        {
            string IP4Address = String.Empty;

            foreach (IPAddress ipa in Dns.GetHostAddresses(HttpContext.Current.Request.UserHostAddress))
            {
                if (ipa.AddressFamily.ToString() == "InterNetwork")
                {
                    IP4Address = ipa.ToString();
                    break;
                }
            }

            if (IP4Address != String.Empty)
            {
                return IP4Address;
            }

            foreach (IPAddress ipa in Dns.GetHostAddresses(Dns.GetHostName()))
            {
                if (ipa.AddressFamily.ToString() == "InterNetwork")
                {
                    IP4Address = ipa.ToString();
                    break;
                }
            }

            return IP4Address;
        }

        public static IPAddress GetIP4Address()
        {
            IPAddress IP4Address = null;

            foreach (IPAddress ipa in Dns.GetHostAddresses(HttpContext.Current.Request.UserHostAddress))
            {
                if (ipa.AddressFamily.ToString() == "InterNetwork")
                {
                    IP4Address = ipa;
                    break;
                }
            }

            if (IP4Address != null)
            {
                return IP4Address;
            }

            foreach (IPAddress ipa in Dns.GetHostAddresses(Dns.GetHostName()))
            {
                if (ipa.AddressFamily.ToString() == "InterNetwork")
                {
                    IP4Address = ipa;
                    break;
                }
            }

            return IP4Address;
        }
    }
}