namespace iMortacci
{
    using System;
    using System.Collections.Generic;
    using Newtonsoft.Json;
    using Newtonsoft.Json.Converters;

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
}
