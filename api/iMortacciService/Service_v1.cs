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
    using Gateway.Utilities;
    using iMortacci.Properties;
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
        private Settings _settings;

        public Service_v1()
        {
            this._settings = Properties.Settings.Default;
        }

        // =====================================================================
        // HELLO
        // =====================================================================
        #region Show/hide

        [WebGet(UriTemplate = "{format}/hello")]
        public string GetHello(string format)
        {
            this._SetOutgoingResponseFormat(format);

            return "Hello, World! ;-)";
        }

        #endregion

        // =====================================================================
        // ALBUM
        // =====================================================================
        #region Show/hide

        [WebGet(UriTemplate = "{format}/albums?loadtracks={loadTracks}")]
        public List<album> GetAlbums(string format, string loadTracks)
        {
            this._SetOutgoingResponseFormat(format);

            bool _loadTracks;

            try
            {
                _loadTracks = bool.Parse(loadTracks);
            }
            catch (ArgumentNullException)
            {
                _loadTracks = false;
            }

            return this._GetAlbums(_loadTracks);
        }

        [WebGet(UriTemplate = "{format}/albums/{id}?loadtracks={loadTracks}")]
        public album GetAlbumById(string format, string id, string loadTracks)
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
                _loadTracks = bool.Parse(loadTracks);
            }
            catch (FormatException)
            {
                throw new WebFaultException<string>(
                    "The value '{value}' is not a valid boolean value. The value can be either 'true' or 'false'.".HaackFormat(new
                    {
                        value = loadTracks
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

        [WebGet(UriTemplate = "{format}/tracks")]
        public List<track> GetTracks(string format)
        {
            this._SetOutgoingResponseFormat(format);

            return this._GetTracks();
        }

        [WebGet(UriTemplate = "{format}/tracks/{id}")]
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

        [WebInvoke(UriTemplate = "{format}/tracks/{id}/update?playback_count={count}", Method = "PUT")]
        public string UpdatePlaybackCount(string format, string id, string count)
        {
            this._SetOutgoingResponseFormat(format);

            uint _id;
            uint _count;

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

            try
            {
                _count = uint.Parse(count);
            }
            catch (FormatException)
            {
                throw new WebFaultException<string>(
                    "The value '{value}' is not a valid count. The count must be an integer.".HaackFormat(new
                    {
                        value = count
                    }),
                    HttpStatusCode.BadRequest);
            }
            catch (OverflowException ex)
            {
                throw new WebFaultException<string>(ex.Message, HttpStatusCode.BadRequest);
            }

            return this._UpdatePlaybackCount(_id, _count);
        }

        #endregion

        // =====================================================================
        // SOUNDCLOUD
        // =====================================================================
        #region Show/hide

        [WebGet(UriTemplate = "{format}/reload?force={forceReload}")]
        public string Reload(string format, string forceReload)
        {
            this._SetOutgoingResponseFormat(format);

            bool _forceReload;

            try
            {
                _forceReload = bool.Parse(forceReload);
            }
            catch (ArgumentNullException)
            {
                _forceReload = false;
            }

            return this._Reload(_forceReload);
        }

        #endregion

        // =====================================================================
        // CONFIGURATION
        // =====================================================================
        #region Show/hide

        [WebGet(UriTemplate = "{format}/config")]
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

        [WebGet(UriTemplate = "{format}/latest")]
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
            if (string.Equals("json", format, StringComparison.OrdinalIgnoreCase))
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

        private string _Reload(bool forceReload = false)
        {
            WebClient client = new WebClient();

            // Collections are served in partitions limited to newAlbum maximum of 50 items.
            // If newAlbum larger value for limit is passed, it is set to 50.
            // Ref.: http://github.com/soundcloud/api/wiki/07-Collections
            string baseUri = "{api_uri}/users/{username}/playlists{format}?consumer_key={client_id}&limit={limit}".HaackFormat(new
            {
                api_uri = this._settings.SCAPIUri,
                username = this._settings.SCUserName,
                format = this._settings.SCResponseFormat,
                client_id = this._settings.SCClientID,
                limit = this._settings.SCCollectionPartitionMaxItemNumber <= 50 ? this._settings.SCCollectionPartitionMaxItemNumber : 50
            });

            // Download all playlists from SoundCloud
            List<SCPlaylist> playlists = new List<SCPlaylist>();
            uint offset = 0;
            while (true)
            {
                string address = "{base_uri}&offset={offset}".HaackFormat(new
                {
                    base_uri = baseUri,
                    offset = offset
                });
                string content = client.DownloadString(address);
                List<SCPlaylist> list = JsonConvert.DeserializeObject<List<SCPlaylist>>(content);
                if (list.Count > 0)
                {
                    playlists.AddRange(list);
                }

                // If you receive fewer items than requested, you are at the end of the collection.
                if (list.Count < this._settings.SCCollectionPartitionMaxItemNumber)
                {
                    break;
                }

                offset += this._settings.SCCollectionPartitionMaxItemNumber;
            }

            string serializedPlaylists = JsonConvert.SerializeObject(playlists);
            string currChecksum = serializedPlaylists.GetMD5Hash().ToLower();

            // Update either if latest version information is empty or latest checksum won't much the current one
            if (HttpContext.Current.Application["latest_version"] == null ||
                currChecksum != ((version)HttpContext.Current.Application["latest_version"]).hash ||
                forceReload)
            {
                using (var context = new IMortacciEntities())
                {
                    context.ContextOptions.ProxyCreationEnabled = false;

                    // Take downloadable playlists only
                    #region

                    foreach (SCPlaylist plist in playlists.Where(p => !p.downloadable.HasValue || p.downloadable == true))
                    {
                        album _album;

                        // Add new album if missing
                        if ((_album = context.album.Include("tracks").Where(a => a.id == plist.id).FirstOrDefault()) == null)
                        {
                            context.album.AddObject((_album = new album()));
                            _album.id = plist.id;
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
                                new string[] { this._settings.AlternateDescriptionSeparator }, 2, StringSplitOptions.None);

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

                        // Take downloable tracks only
                        #region

                        foreach (SCTrack track in plist.tracks.Where(t => t.download_url != null))
                        {
                            track _track;

                            // Add new track if missing
                            if ((_track = _album.tracks.Where(t => t.id == track.id).FirstOrDefault()) == null)
                            {
                                _album.tracks.Add((_track = new track()));
                                _track.id = track.id;
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
                                    new string[] { this._settings.AlternateDescriptionSeparator }, 2, StringSplitOptions.None);

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

                        #endregion
                    }

                    #endregion

                    string filename = string.Format("{0}.json", currChecksum);
                    string savePath = Path.Combine(this._settings.HistoryDirectory, filename);

                    try
                    {
                        // Before saving any changes to the database, we try to save latest content
                        File.WriteAllText(savePath, serializedPlaylists, Encoding.UTF8);
                    }
                    catch (Exception ex)
                    {
                        throw new WebFaultException<string>(ex.Message, HttpStatusCode.InternalServerError);
                    }

                    version newVersion = new version();

                    try
                    {
                        context.SaveChanges();

                        // If changes to database are succeeded, we add a new version to history
                        newVersion.hash = currChecksum;
                        newVersion.created_at = DateTime.Now;
                        newVersion.object_count = context.track.Count();
                        newVersion.download_url = "{baseUri}/{filename}".HaackFormat(new
                        {
                            baseUri = this._settings.BaseDownloadUri,
                            filename = filename
                        });
                        context.version.AddObject(newVersion);

                        context.SaveChanges();
                    }
                    catch (UpdateException ex)
                    {
                        try
                        {
                            // There was a problem with updates to the database, therefore we must delete previously created file
                            File.Delete(savePath);
                        }
                        catch (Exception)
                        {
                            throw new WebFaultException<string>(ex.Message, HttpStatusCode.InternalServerError);
                        }

                        throw new WebFaultException<string>(ex.InnerException.Message, HttpStatusCode.InternalServerError);
                    }

                    // Update application state to match with the current values
                    HttpContext.Current.Application["latest_version"] = newVersion;
                }
            }

            return this._settings.SuccessResponseMessage;
        }

        private string _UpdatePlaybackCount(uint trackId, uint count)
        {
            using (var context = new IMortacciEntities())
            {
                context.ContextOptions.ProxyCreationEnabled = false;

                track _track;

                if ((_track = context.track.Where(t => t.id == trackId).FirstOrDefault()) == null)
                {
                    throw new WebFaultException<string>(
                        "There is no track with the id '{id}'".HaackFormat(new
                        {
                            id = trackId
                        }),
                        HttpStatusCode.NotFound);
                }

                try
                {
                    _track.playback_count += Convert.ToInt32(count);
                }
                catch (OverflowException ex)
                {
                    throw new WebFaultException<string>(ex.Message, HttpStatusCode.BadRequest);
                }

                context.SaveChanges();
            }

            return this._settings.SuccessResponseMessage;
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
            }

            return (version)HttpContext.Current.Application["latest_version"];
        }

        #endregion
    }
}
