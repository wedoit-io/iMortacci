namespace iMortacci
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Web;

    public class APIConfiguration
    {
        public const string APIAlternateDescSeparatorKey = "api_alternate_desc_separator";
        public const string APIDownloadDirKey = "api_download_dir";
        public const string APIDownloadURLKey = "api_download_url";
        public const string APISuccessMessageKey = "api_success_message";

        public const string APNSEnabledKey = "apns_enabled";
        public const string APNSAppNameKey = "apns_app_name";
        public const string APNSAppSecretKey = "apns_app_secret";
        
        public const string SCAPIURLKey = "sc_api_url";
        public const string SCAppNameKey = "sc_app_name";
        public const string SCClientIdKey = "sc_client_id";
        public const string SCClientSecretKey = "sc_client_secret";
        public const string SCCollectionPartitionMaxItemNumberKey = "sc_collection_partition_max_item_number";
        public const string SCUsernameKey = "sc_username";

        private List<configuration> _configs;

        public APIConfiguration()
        {
            using (var context = new IMortacciEntities())
            {
                context.ContextOptions.ProxyCreationEnabled = false;

                this._configs = context.configuration.ToList();
            }
        }

        public string GetValueForKey(string key)
        {
            return this._configs.Where(c => c.key == key).FirstOrDefault().value;
        }
    }
}