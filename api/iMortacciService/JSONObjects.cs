namespace iMortacci
{
    using System;
    using System.Collections.Generic;
    using Newtonsoft.Json;
    using Newtonsoft.Json.Converters;

    // =====================================================================
    // iMortacci Objects
    // =====================================================================
    #region Show/hide

    public enum IMORCounterLikeStatus
    {
        Neutral = 0,
        UnPublished = 1,
        Published = 2,
    }

    [JsonObject]
    public class IMORCounterInput
    {
        public int id { get; set; }

        public IMORCounterLikeStatus like_status { get; set; }

        public int user_playback_count { get; set; }
    }

    #endregion

    // =====================================================================
    // SoundCloud Objects
    // =====================================================================
    #region Show/hide

    [JsonObject]
    public class SCPlaylist
    {
        public int id { get; set; }

        public string permalink { get; set; }

        public string title { get; set; }

        public string description { get; set; }

        [JsonConverter(typeof(IsoDateTimeConverter))]
        public DateTime created_at { get; set; }

        public int? release_year { get; set; }

        public int? release_month { get; set; }

        public int? release_day { get; set; }

        public string artwork_url { get; set; }

        public List<SCTrack> tracks { get; set; }

        public bool? downloadable { get; set; }
    }

    [JsonObject]
    public class SCTrack
    {
        public int id { get; set; }

        public string permalink { get; set; }

        public string title { get; set; }

        public string description { get; set; }

        [JsonConverter(typeof(IsoDateTimeConverter))]
        public DateTime created_at { get; set; }

        public int? release_year { get; set; }

        public int? release_month { get; set; }

        public int? release_day { get; set; }

        public string download_url { get; set; }

        public string waveform_url { get; set; }
    }

    #endregion
}
