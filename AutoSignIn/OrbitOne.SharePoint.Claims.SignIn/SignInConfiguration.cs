using System;
using System.Runtime.InteropServices;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using Microsoft.SharePoint;
using Microsoft.SharePoint.Administration;

namespace OrbitOne.SharePoint.Claims.SignIn
{
    /// <summary>
    /// Holds configuration data for our auto-sign in login page.
    /// </summary>
    /// <remarks>
    /// When an IP address is associated with a specific authentication provider, and that configuration stored with the SPWebApplication instance,
    /// the custom autosignin.aspx page will automatically direct users from matching source addresses to the appropriate authentication provider page.
    /// </remarks>
    [Guid("4C28E13B-FDE1-448B-BEEC-31224A98BA2C")]
    public class SignInConfiguration
        : SPPersistedObject
    {
        [Persisted()]
        private Dictionary<string, string> m_providerMappings = new Dictionary<string, string>();
        [Persisted()]
        private Dictionary<string, string> m_signinPageMappings = new Dictionary<string, string>();

        public SignInConfiguration()
            : base()
        { }

        public SignInConfiguration(string name, SPPersistedObject parent)
            : base(name, parent)
        { }

        public SignInConfiguration(string name, SPPersistedObject parent, Guid id)
            : base(name, parent, id)
        { }

        public static Guid ObjectId
        {
            get { return new Guid("4C28E13B-FDE1-448B-BEEC-31224A98BA2C"); }
        }

        public void AddProviderMapping(string sourceAddress, string authProviderName)
        {
            if (m_providerMappings.ContainsKey(sourceAddress))
            {
                m_providerMappings[sourceAddress] = authProviderName;
            }
            else
            {
                m_providerMappings.Add(sourceAddress, authProviderName);
            }
        }

        public void RemoveProviderMapping(string sourceAddress, string authProviderName)
        {
            if (m_providerMappings.ContainsKey(sourceAddress))
            {
                m_providerMappings.Remove(sourceAddress);
            }
        }

        public void Clear()
        {
            m_providerMappings.Clear();
        }

        public Dictionary<string, string> ProviderMappings
        {
            get { return m_providerMappings; }
        }

        public Dictionary<string, string> SingInPageMappings
        {
            get { return m_signinPageMappings; }
        }
    }
}
