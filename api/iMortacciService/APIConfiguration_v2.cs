namespace iMortacci
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Web;

    public class APIConfiguration_v2
    {
        // API settings
        public const string APIAlternateDescSeparatorKey = "api_alternate_desc_separator";
        public const string APIDownloadDirKey = "api_download_dir";
        public const string APIDownloadURLKey = "api_download_url";
        public const string APISuccessMessageKey = "api_success_message";
        public const string APISecret = "api_secret";

        // APNS settings
        public const string APNSEnabledKey = "apns_enabled";
        public const string APNSAppNameKey = "apns_app_name";
        public const string APNSAppSecretKey = "apns_app_secret";
        public const string APNSAppIncludeMessage = "apns_include_message";
        public const string APNSAppIncludeBadge = "apns_include_badge";
        public const string APNSAppIncludeSound = "apns_include_sound";

        // SoundCloud settings
        public const string SCAPIURLKey = "sc_api_url";
        public const string SCAppNameKey = "sc_app_name";
        public const string SCClientIdKey = "sc_client_id";
        public const string SCClientSecretKey = "sc_client_secret";
        public const string SCCollectionPartitionMaxItemNumberKey = "sc_collection_partition_max_item_number";
        public const string SCUsernameKey = "sc_username";

        // Debug settings
        public const string DebugAPNSAppNameKey = "debug_apns_app_name";
        public const string DebugAPNSAppSecretKey = "debug_apns_app_secret";
        public const string DebugAPNSMessage = "debug_apns_message";
        public const string DebugAPNSSound = "debug_apns_sound";
        public const string DebugAPNSBadge = "debug_apns_badge";

        private List<configuration> _configs;

        public APIConfiguration_v2()
        {
            using (var context = new IMortacciEntities())
            {
                context.ContextOptions.ProxyCreationEnabled = false;

                this._configs = context.configuration.ToList();
            }
        }

        public List<configuration> Cache
        {
            get
            {
                return this._configs;
            }

            set
            {
                this._configs = value;
            }
        }

        public string GetCachedValueForKey(string key)
        {
            return this._configs.Where(c => c.key == key).FirstOrDefault().value;
        }

        public string GetValueForKey(string key)
        {
            using (var context = new IMortacciEntities())
            {
                context.ContextOptions.ProxyCreationEnabled = false;

                return context.configuration.Where(c => c.key == key).FirstOrDefault().value;
            }
        }
    }
}