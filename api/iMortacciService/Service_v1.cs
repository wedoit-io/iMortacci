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
        private APIConfiguration config;

        public Service_v1()
        {
            this.config = (APIConfiguration)HttpContext.Current.Application["api_config"];
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

            bool _force;

            try
            {
                _force = bool.Parse(force);
            }
            catch (ArgumentNullException)
            {
                _force = false;
            }

            bool _notify;

            try
            {
                _notify = bool.Parse(notify);
            }
            catch (ArgumentNullException)
            {
                // By default push notifications will be sent
                _notify = true;
            }

            return this._Reload(_force, _notify);
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

        private version _Reload(bool forceReload = false, bool notify = true)
        {
            WebClient client = new WebClient();

            // Collections are served in partitions limited to newAlbum maximum of 50 items.
            // If newAlbum larger value for limit is passed, it is set to 50.
            // Ref.: http://github.com/soundcloud/api/wiki/07-Collections
            uint collectionPartitionMaxItemNumber = uint.Parse(this.config.GetValueForKey(APIConfiguration.SCCollectionPartitionMaxItemNumberKey));
            collectionPartitionMaxItemNumber = collectionPartitionMaxItemNumber <= 50 ? collectionPartitionMaxItemNumber : 50;

            string baseURL = "{api_url}/users/{username}/playlists.json?consumer_key={client_id}&limit={limit}".HaackFormat(new
            {
                api_url = this.config.GetValueForKey(APIConfiguration.SCAPIURLKey),
                username = this.config.GetValueForKey(APIConfiguration.SCUsernameKey),
                client_id = this.config.GetValueForKey(APIConfiguration.SCClientIdKey),
                limit = collectionPartitionMaxItemNumber
            });

            // Download all playlists from SoundCloud
            List<SCPlaylist> playlists = new List<SCPlaylist>();
            uint offset = 0;
            while (true)
            {
                string address = "{base_url}&offset={offset}".HaackFormat(new
                {
                    base_url = baseURL,
                    offset = offset
                });
                string content = client.DownloadString(address);
                List<SCPlaylist> list = JsonConvert.DeserializeObject<List<SCPlaylist>>(content);
                if (list.Count > 0)
                {
                    playlists.AddRange(list);
                }

                // If you receive fewer items than requested, you are at the end of the collection.
                if (list.Count < collectionPartitionMaxItemNumber)
                {
                    break;
                }

                offset += collectionPartitionMaxItemNumber;
            }

            // Filter SoundCloud response in this way:
            //   * Remove any playlist or track that is not downloadable
            //   * Remove any playlist or track that has a future release date
            //   * Remove any playlist that doesn't have at least one downloadable track in it
            List<SCPlaylist> filteredPlaylists = new List<SCPlaylist>();

            playlists.RemoveAll(
                p => !p.downloadable.GetValueOrDefault(true) ||
                (p.release_year.HasValue && p.release_month.HasValue && p.release_day.HasValue &&
                new DateTime((int)p.release_year, (int)p.release_month, (int)p.release_day) > DateTime.Now));
            foreach (SCPlaylist p in playlists)
            {
                p.tracks.RemoveAll(t => string.IsNullOrWhiteSpace(t.download_url) ||
                (t.release_year.HasValue && t.release_month.HasValue && t.release_day.HasValue &&
                new DateTime((int)t.release_year, (int)t.release_month, (int)t.release_day) > DateTime.Now));
                if (p.tracks.Count > 0)
                {
                    filteredPlaylists.Add(p);
                }
            }

            string serializedPlaylists = JsonConvert.SerializeObject(filteredPlaylists);
            string currChecksum = serializedPlaylists.GetMD5Hash().ToLower();

            // Update either if latest version information is empty or latest checksum won't much the current one
            if (HttpContext.Current.Application["latest_version"] == null ||
                currChecksum != ((version)HttpContext.Current.Application["latest_version"]).hash ||
                forceReload)
            {
                uint newAlbumsCounter = 0;
                uint newTracksCounter = 0;

                using (var context = new IMortacciEntities())
                {
                    context.ContextOptions.ProxyCreationEnabled = false;

                    // Insert/update albums and playlists
                    #region Show/hide

                    foreach (SCPlaylist plist in filteredPlaylists)
                    {
                        album _album;

                        // Add new album if missing
                        if ((_album = context.album.Include("tracks").Where(a => a.id == plist.id).FirstOrDefault()) == null)
                        {
                            context.album.AddObject((_album = new album()));
                            _album.id = plist.id;
                            newAlbumsCounter++;
                        }

                        // Update fields
                        // =============
                        _album.slug = plist.permalink;
                        _album.title = plist.title;

                        if (string.IsNullOrWhiteSpace(plist.description))
                        {
                            _album.description = null;
                        }
                        else
                        {
                            string[] _splitted = plist.description.Split(
                                new string[] { this.config.GetValueForKey(APIConfiguration.APIAlternateDescSeparatorKey) }, 2, StringSplitOptions.None);

                            _album.description = string.IsNullOrWhiteSpace((_splitted[0] = _splitted[0].Trim())) ? null : _splitted[0];
                            _album.alternate_desc = _splitted.Length == 2 ? _splitted[1].Trim() : _album.alternate_desc;
                        }

                        _album.created_at = plist.created_at;
                        if (plist.release_year.HasValue &&
                            plist.release_month.HasValue &&
                            plist.release_day.HasValue)
                        {
                            _album.release_at = new DateTime(
                                plist.release_year.Value,
                                plist.release_month.Value,
                                plist.release_day.Value);
                        }

                        _album.artwork_url = plist.artwork_url;

                        foreach (SCTrack track in plist.tracks)
                        {
                            track _track;

                            // Add new track if missing
                            if ((_track = _album.tracks.Where(t => t.id == track.id).FirstOrDefault()) == null)
                            {
                                _album.tracks.Add((_track = new track()));
                                _track.id = track.id;
                                newTracksCounter++;
                            }

                            // Update fields
                            // =============
                            _track.slug = track.permalink;
                            _track.title = track.title;
                            _track.description = track.description;

                            if (string.IsNullOrWhiteSpace(track.description))
                            {
                                _track.description = null;
                            }
                            else
                            {
                                string[] _splitted = track.description.Split(
                                    new string[] { this.config.GetValueForKey(APIConfiguration.APIAlternateDescSeparatorKey) }, 2, StringSplitOptions.None);

                                _track.description = string.IsNullOrWhiteSpace((_splitted[0] = _splitted[0].Trim())) ? null : _splitted[0];
                                _track.alternate_desc = _splitted.Length == 2 ? _splitted[1].Trim() : _track.alternate_desc;
                            }

                            _track.created_at = track.created_at;
                            if (track.release_year.HasValue &&
                                track.release_month.HasValue &&
                                track.release_day.HasValue)
                            {
                                _track.release_at = new DateTime(
                                    track.release_year.Value,
                                    track.release_month.Value,
                                    track.release_day.Value);
                            }

                            _track.download_url = track.download_url;
                            _track.waveform_url = track.waveform_url;
                        }
                    }

                    #endregion

                    try
                    {
                        context.SaveChanges();
                    }
                    catch (UpdateException ex)
                    {
                        throw new WebFaultException<string>(ex.InnerException.Message, HttpStatusCode.InternalServerError);
                    }

                    string filename = string.Format("{0}.json", currChecksum);
                    string savePath = Path.Combine(this.config.GetValueForKey(APIConfiguration.APIDownloadDirKey), filename);

                    // Add a new version to history
                    version newVersion = new version();
                    newVersion.hash = currChecksum;
                    newVersion.created_at = DateTime.Now;
                    newVersion.object_count = context.track.Count();
                    newVersion.download_url = filename;
                    context.version.AddObject(newVersion);

                    try
                    {
                        context.SaveChanges();
                    }
                    catch (UpdateException ex)
                    {
                        throw new WebFaultException<string>(ex.InnerException.Message, HttpStatusCode.InternalServerError);
                    }

                    string latestVersion = JsonConvert.SerializeObject(context.album.Include("tracks"));

                    try
                    {
                        // Save latest content to file
                        File.WriteAllText(savePath, latestVersion, Encoding.UTF8);
                    }
                    catch (Exception ex)
                    {
                        // If save fails we should delete previously added last version 
                        context.version.DeleteObject(context.version.Where(v => v.hash == currChecksum).FirstOrDefault());

                        throw new WebFaultException<string>(ex.Message, HttpStatusCode.InternalServerError);
                    }

                    // Update application state to match with the current values
                    newVersion.download_url = "{base_url}/{download_url}".HaackFormat(new
                    {
                        base_url = this.config.GetValueForKey(APIConfiguration.APIDownloadURLKey),
                        download_url = newVersion.download_url
                    });
                    HttpContext.Current.Application["latest_version"] = newVersion;
                }

                // If we've got there, then everything went well. Notify users.
                bool _apnsEnabled;
                try
                {
                    _apnsEnabled = bool.Parse(this.config.GetValueForKey(APIConfiguration.APNSEnabledKey));
                }
                catch (Exception)
                {
                    _apnsEnabled = false;
                }

                if (_apnsEnabled && newTracksCounter > 0)
                {
                    string msg = string.Empty;

                    if (newAlbumsCounter > 0)
                    {
                        if (newAlbumsCounter == 1)
                        {
                            msg += "C'è un nuovo dialetto";
                        }
                        else
                        {
                            msg += string.Format("Ci sono {0} nuovi dialetti", newAlbumsCounter);
                        }
                    }

                    if (newTracksCounter == 1)
                    {
                        if (string.IsNullOrWhiteSpace(msg))
                        {
                            msg += "C'è un mortaccione nuovo che puoi aggiornare!";
                        }
                        else
                        {
                            msg += " e un mortaccione nuovo che puoi aggiornare!";
                        }
                    }
                    else
                    {
                        if (string.IsNullOrWhiteSpace(msg))
                        {
                            msg += string.Format("Ci sono {0} mortaccioni nuovi che puoi aggiornare!", newTracksCounter);
                        }
                        else
                        {
                            msg += string.Format(" e {0} mortaccioni nuovi che puoi aggiornare!", newTracksCounter);
                        }
                    }

                    NotificatoreSoapClient apns = new NotificatoreSoapClient();
                    try
                    {
                        apns.SendNotification(
                            this.config.GetValueForKey(APIConfiguration.APNSAppSecretKey),
                            this.config.GetValueForKey(APIConfiguration.APNSAppNameKey),
                            msg,
                            string.Empty,
                            "default",
                            (int)newTracksCounter);
                    }
                    catch (Exception ex)
                    {
                        apns.Abort();

                        throw new WebFaultException<string>(ex.Message, HttpStatusCode.InternalServerError);
                    }

                    apns.Close();
                }
            }

            return this._GetLatestVersion();
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
                    base_url = this.config.GetValueForKey(APIConfiguration.APIDownloadURLKey),
                    download_url = v.download_url
                });
            }

            return (version)HttpContext.Current.Application["latest_version"];
        }

        #endregion
    }
}
