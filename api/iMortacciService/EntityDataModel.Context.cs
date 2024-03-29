//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

using System;
using System.Data.Objects;
using System.Data.EntityClient;

namespace iMortacci
{
    public partial class IMortacciEntities : ObjectContext
    {
        public const string ConnectionString = "name=IMortacciEntities";
        public const string ContainerName = "IMortacciEntities";
    
        #region Constructors
    
        public IMortacciEntities()
            : base(ConnectionString, ContainerName)
        {
            this.ContextOptions.LazyLoadingEnabled = true;
        }
    
        public IMortacciEntities(string connectionString)
            : base(connectionString, ContainerName)
        {
            this.ContextOptions.LazyLoadingEnabled = true;
        }
    
        public IMortacciEntities(EntityConnection connection)
            : base(connection, ContainerName)
        {
            this.ContextOptions.LazyLoadingEnabled = true;
        }
    
        #endregion
    
        #region ObjectSet Properties
    
        public ObjectSet<configuration> configuration
        {
            get { return _configuration  ?? (_configuration = CreateObjectSet<configuration>("configuration")); }
        }
        private ObjectSet<configuration> _configuration;
    
        public ObjectSet<album> album
        {
            get { return _album  ?? (_album = CreateObjectSet<album>("album")); }
        }
        private ObjectSet<album> _album;
    
        public ObjectSet<version> version
        {
            get { return _version  ?? (_version = CreateObjectSet<version>("version")); }
        }
        private ObjectSet<version> _version;
    
        public ObjectSet<track> track
        {
            get { return _track  ?? (_track = CreateObjectSet<track>("track")); }
        }
        private ObjectSet<track> _track;
    
        public ObjectSet<track_counter> track_counter
        {
            get { return _track_counter  ?? (_track_counter = CreateObjectSet<track_counter>("track_counter")); }
        }
        private ObjectSet<track_counter> _track_counter;
    
        public ObjectSet<track_slug> track_slug
        {
            get { return _track_slug  ?? (_track_slug = CreateObjectSet<track_slug>("track_slug")); }
        }
        private ObjectSet<track_slug> _track_slug;

        #endregion
    }
}
