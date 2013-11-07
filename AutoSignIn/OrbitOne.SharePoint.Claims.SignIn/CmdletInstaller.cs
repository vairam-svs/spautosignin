using System.ComponentModel;
using System.Management.Automation;

namespace OrbitOne.SharePoint.Claims.SignIn
{
    [RunInstaller(true)]
    public class CmdletInstaller
        : PSSnapIn
    {
        public CmdletInstaller()
            : base()
        { }

        public override string Name
        {
            get { return "ClaimsSignInAdmin"; }
        }

        public override string Vendor
        {
            get { return "Sample Originally by Bryan Porter, enhanced by Orbit One"; }
        }

        public override string Description
        {
            get { return "This is a PowerShell snap-in that adds cmdlets to administer the auto-signin sample."; }
        }
    }
}
