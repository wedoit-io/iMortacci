namespace iMortacci
{
    using System;
    using System.Collections.Generic;
    using System.Data;
    using System.IO;
    using System.Linq;
    using System.Net;
    using System.ServiceModel;
    using System.ServiceModel.Activation;
    using System.ServiceModel.Web;
    using System.Text;
    using System.Web;
    using ApexNetPushNotificationServiceReference;
    using Gateway.Utilities;
    using Newtonsoft.Json;

    // Start the service and browse to http://<machine_name>:<port>/ServiceV1/help to view the service's generated help page
    // NOTE: By default, a new instance of the service is created for each call; change the InstanceContextMode to Single if you want
    // a single instance of the service to process all calls.
    [ServiceContract]
    [AspNetCompatibilityRequirements(RequirementsMode = AspNetCompatibilityRequirementsMode.Allowed)]
    [ServiceBehavior(InstanceContextMode = InstanceContextMode.PerCall)]
    //// NOTE: If the service is renamed, remember to update the global.asax.cs file
    public class Service_v1
    {
        private APIConfiguration_v2 config;

        // NOTE: When you create a new version update the constructor code below
        public Service_v1()
        {
            this.config = (APIConfiguration_v2)HttpContext.Current.Application["api_config_cache"];
        }

        // =====================================================================
        // PING
        // =====================================================================
        #region Show/hide

        [WebGet(UriTemplate = "ping?format={format}")]
        public string GetPong(string format)
        {
            this._SetOutgoingResponseFormat(format);

            return "pong";
        }

        #endregion

        // =====================================================================
        // ALBUM
        // =====================================================================
        #region Show/hide

        [WebGet(UriTemplate = "albums?format={format}&loadtracks={trueFalse}")]
        public List<album> GetAlbums(string format, string trueFalse)
        {
            this._SetOutgoingResponseFormat(format);

            bool _loadTracks;

            try
            {
                _loadTracks = bool.Parse(trueFalse);
            }
            catch (ArgumentNullException)
            {
                _loadTracks = false;
            }

            return this._GetAlbums(_loadTracks);
        }

        [WebGet(UriTemplate = "albums/{id}?format={format}&loadtracks={trueFalse}")]
        public album GetAlbumById(string format, string id, string trueFalse)
        {
            this._SetOutgoingResponseFormat(format);

            uint _id;
            bool _loadTracks;

            try
            {
                _id = uint.Parse(id);
            }
            catch (FormatException)
            {
                throw new WebFaultException<string>(
                    "The value '{id}' is not a valid album id. The id must be an integer.".HaackFormat(new
                    {
                        id = id
                    }),
                    HttpStatusCode.BadRequest);
            }
            catch (OverflowException ex)
            {
                throw new WebFaultException<string>(ex.Message, HttpStatusCode.BadRequest);
            }

            try
            {
                _loadTracks = bool.Parse(trueFalse);
            }
            catch (FormatException)
            {
                throw new WebFaultException<string>(
                    "The value '{value}' is not a valid boolean value. The value can be either 'true' or 'false'.".HaackFormat(new
                    {
                        value = trueFalse
                    }),
                    HttpStatusCode.BadRequest);
            }
            catch (ArgumentNullException)
            {
                _loadTracks = false;
            }

            return this._GetAlbums(_loadTracks, _id).FirstOrDefault();
        }

        #endregion

        // =====================================================================
        // TRACK
        // =====================================================================
        #region Show/hide

        [WebGet(UriTemplate = "tracks?format={format}")]
        public List<track> GetTracks(string format)
        {
            this._SetOutgoingResponseFormat(format);

            return this._GetTracks();
        }

        [WebGet(UriTemplate = "tracks/{id}?format={format}")]
        public track GetTrackById(string format, string id)
        {
            this._SetOutgoingResponseFormat(format);

            uint _id;

            try
            {
                _id = uint.Parse(id);
            }
            catch (FormatException)
            {
                throw new WebFaultException<string>(
                    "The value '{id}' is not a valid track id. The id must be an integer.".HaackFormat(new
                    {
                        id = id
                    }),
                    HttpStatusCode.BadRequest);
            }
            catch (OverflowException ex)
            {
                throw new WebFaultException<string>(ex.Message, HttpStatusCode.BadRequest);
            }

            return this._GetTracks(_id).FirstOrDefault();
        }

        [WebGet(UriTemplate = "counters?format={format}")]
        public List<track_counter> GetCounters(string format)
        {
            this._SetOutgoingResponseFormat(format);

            return this._GetCounters();
        }

        [WebGet(UriTemplate = "counters/{id}?format={format}")]
        public track_counter GetCounterById(string format, string id)
        {
            this._SetOutgoingResponseFormat(format);

            uint _id;

            try
            {
                _id = uint.Parse(id);
            }
            catch (FormatException)
            {
                throw new WebFaultException<string>(
                    "The value '{id}' is not a valid track id. The id must be an integer.".HaackFormat(new
                    {
                        id = id
                    }),
                    HttpStatusCode.BadRequest);
            }
            catch (OverflowException ex)
            {
                throw new WebFaultException<string>(ex.Message, HttpStatusCode.BadRequest);
            }

            return this._GetCounters(_id).FirstOrDefault();
        }

        [WebGet(UriTemplate = "slugs/{id}?format={format}")]
        public track_slug GetSlugById(string format, string id)
        {
            this._SetOutgoingResponseFormat(format);

            uint _id;

            try
            {
                _id = uint.Parse(id);
            }
            catch (FormatException)
            {
                throw new WebFaultException<string>(
                    "The value '{id}' is not a valid track id. The id must be an integer.".HaackFormat(new
                    {
                        id = id
                    }),
                    HttpStatusCode.BadRequest);
            }
            catch (OverflowException ex)
            {
                throw new WebFaultException<string>(ex.Message, HttpStatusCode.BadRequest);
            }

            return this._GetSlugs(_id).FirstOrDefault();
        }

        [WebInvoke(
            Method = "PUT",
            UriTemplate = "counters?format={format}",
            RequestFormat = WebMessageFormat.Json)]
        public List<track_counter> UpdateCounters(string format, List<IMORCounterInput> counters)
        {
            this._SetOutgoingResponseFormat(format);

            return this._UpdateCounters(counters);
        }

        #endregion

        // =====================================================================
        // SOUNDCLOUD
        // =====================================================================
        #region Show/hide

        [WebGet(UriTemplate = "reload?format={format}&force={force}&notify={notify}")]
        public version Reload(string format, string force, string notify)
        {
            this._SetOutgoingResponseFormat(format);

            throw new WebFaultException<string>(
                "There is an updated version of this API, use that one instead.",
                HttpStatusCode.Forbidden);
        }

        #endregion

        // =====================================================================
        // CONFIGURATION
        // =====================================================================
        #region Show/hide

        [WebGet(UriTemplate = "config?format={format}")]
        public List<configuration> GetConfigurations(string format)
        {
            this._SetOutgoingResponseFormat(format);

            return this._GetConfigurations();
        }

        #endregion

        // =====================================================================
        // VERSION HISTORY
        // =====================================================================
        #region

        [WebGet(UriTemplate = "latest?format={format}")]
        public version GetLatestVersion(string format)
        {
            this._SetOutgoingResponseFormat(format);

            return this._GetLatestVersion();
        }

        #endregion

        // >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        // __INTERNAL_METHODS__
        // <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
        #region Show/hide

        private void _SetOutgoingResponseFormat(string format)
        {
            if (string.Equals("json", format, StringComparison.OrdinalIgnoreCase) ||
                string.IsNullOrWhiteSpace(format))
            {
                WebOperationContext.Current.OutgoingResponse.Format = WebMessageFormat.Json;
            }
            else if (string.Equals("xml", format, StringComparison.OrdinalIgnoreCase))
            {
                WebOperationContext.Current.OutgoingResponse.Format = WebMessageFormat.Xml;
            }
            else
            {
                throw new WebFaultException<string>(
                    "Unknown response format! Either 'json' or 'xml' must be specified.",
                    HttpStatusCode.BadRequest);
            }
        }

        private List<album> _GetAlbums(bool loadTracks, uint? id = null)
        {
            using (var context = new IMortacciEntities())
            {
                context.ContextOptions.ProxyCreationEnabled = false;

                var query = loadTracks ?
                    context.album.Include("tracks").AsQueryable() :
                    context.album.AsQueryable();

                if (id.HasValue)
                {
                    query = query.Where(a => a.id == id);
                }

                return query.ToList();
            }
        }

        private List<track> _GetTracks(uint? id = null)
        {
            using (var context = new IMortacciEntities())
            {
                context.ContextOptions.ProxyCreationEnabled = false;

                var query = context.track.AsQueryable();

                if (id.HasValue)
                {
                    query = query.Where(a => a.id == id);
                }

                return query.ToList();
            }
        }

        private List<track_counter> _GetCounters(uint? id = null)
        {
            using (var context = new IMortacciEntities())
            {
                context.ContextOptions.ProxyCreationEnabled = false;

                var query = context.track_counter.AsQueryable();

                if (id.HasValue)
                {
                    query = query.Where(a => a.id == id);
                }

                return query.ToList();
            }
        }

        private List<track_slug> _GetSlugs(uint? id = null)
        {
            using (var context = new IMortacciEntities())
            {
                context.ContextOptions.ProxyCreationEnabled = false;

                var query = context.track_slug.AsQueryable();

                if (id.HasValue)
                {
                    query = query.Where(a => a.id == id);
                }

                return query.ToList();
            }
        }

        private List<track_counter> _UpdateCounters(List<IMORCounterInput> counters)
        {
            using (var context = new IMortacciEntities())
            {
                context.ContextOptions.ProxyCreationEnabled = false;

                if (counters != null)
                {
                    track track;
                    foreach (IMORCounterInput c in counters)
                    {
                        if ((track = context.track.Where(t => t.id == c.id).FirstOrDefault()) != null)
                        {
                            track.playback_count += c.user_playback_count;
                            if (c.like_status == IMORCounterLikeStatus.UnPublished)
                            {
                                track.like_count++;
                            }
                        }
                    }

                    context.SaveChanges();
                }

                return context.track_counter.ToList();
            }
        }

        private List<configuration> _GetConfigurations()
        {
            using (var context = new IMortacciEntities())
            {
                context.ContextOptions.ProxyCreationEnabled = false;

                return context.configuration.ToList();
            }
        }

        private version _GetLatestVersion()
        {
            if (HttpContext.Current.Application["latest_version"] == null)
            {
                using (var context = new IMortacciEntities())
                {
                    context.ContextOptions.ProxyCreationEnabled = false;

                    if ((HttpContext.Current.Application["latest_version"] =
                        context.version.OrderByDescending(h => h.created_at).FirstOrDefault()) == null)
                    {
                        throw new WebFaultException<string>(
                            "Latest version information is empty, 'reload' and try again.",
                            HttpStatusCode.NotFound);
                    }
                }

                version v = (version)HttpContext.Current.Application["latest_version"];
                v.download_url = "{base_url}/{download_url}".HaackFormat(new
                {
                    base_url = this.config.GetValueForKey(APIConfiguration_v2.APIDownloadURLKey),
                    download_url = v.download_url
                });
            }

            return (version)HttpContext.Current.Application["latest_version"];
        }

        #endregion
    }
}
