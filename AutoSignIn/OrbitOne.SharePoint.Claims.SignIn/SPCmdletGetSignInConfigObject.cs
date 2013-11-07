using System.Management.Automation;
using Microsoft.SharePoint.Administration;
using Microsoft.SharePoint.PowerShell;

namespace OrbitOne.SharePoint.Claims.SignIn
{
    [Cmdlet("Get", "SPSignInConfiguration", DefaultParameterSetName = "DefaultSet")]
    public class SPCmdletGetSignInConfigObject
        : SPCmdlet
    {
        private SPWebApplicationPipeBind m_webAppPipeBind;

        protected override void InternalProcessRecord()
        {
            SPWebApplication webApp = m_webAppPipeBind.Read();

            SignInConfiguration sc = webApp.GetChild<SignInConfiguration>("SignInConfig");

            if (sc == null)
            {
                sc = new SignInConfiguration("SignInConfig", webApp);
            }

            sc.Update();

            base.WriteObject(sc);
        }

        [ValidateNotNull]
        [Parameter(Mandatory=true, ValueFromPipeline=true, Position=0)]
        [Alias(new string[] { "WebApplication", "WebApp"})]
        public SPWebApplicationPipeBind Identity
        {
            get { return m_webAppPipeBind; }
            set { m_webAppPipeBind = value; }
        }
    }
}
