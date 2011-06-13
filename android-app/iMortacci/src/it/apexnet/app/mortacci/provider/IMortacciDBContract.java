package it.apexnet.app.mortacci.provider;


/**
 * Contract class for interacting with {@link IMortacciDBProvider}.
*/

public class IMortacciDBContract {

	public interface Tables
	{
		String ALBUMS = "albums";
		String TRACKS = "tracks";				
	}
	
	public interface Views
	{
		String FAVOURITE_TRACKS_VIEW = "favourite_tracks_view";
	}
	
	public interface TracksColumns
	{
		String ALBUM_ID = "album_id";
		String FK_ALBUM_ID = "fk_album_id";
		String TRACK_ID = "track_id";		
		String DOWNLOAD_URL = "download_url";
		String LIKE_COUNT = "like_count";
		String PLAYBACK_COUNT = "playback_count";
		String SLUG = "slug";
		String DESCRIPTION = "description";
		String STATUS = "status";
		String TITLE = "title";
		String WAVEFORM_URL = "waveform_url";
		String FAVOURITE = "favourite";
	}
	
	public interface AlbumsColumns
	{
		String DESCRIPTION = "description";
		String ALBUM_ID = "album_id";
		String SLUG = "slug";
		String STATUS = "status";
		String TITLE = "title";
	}
	
	public interface FavouriteTracksViewColumns
	{
		String _ID = "_id";
		String ALBUM_DESCRIPTION = "album_description";
		String ALBUM_ID = "album_id";
		String ALBUM_SLUG = "album_slug";
		String ALBUM_STATUS = "album_status";
		String ALBUM_TITLE = "album_title";
		String TRACK_DOWNLOAD_URL = "track_download_url";
		String TRACK_ID = "track_id";
		String TRACK_LIKE_COUNT = "track_like_count";
		String TRACK_PLAYBACK_COUNT = "track_playback_count";
		String TRACK_SLUG = "track_slug";
		String TRACK_DESCRIPTION = "track_description";
		String TRACK_STATUS = "track_status";
		String TRACK_TITLE = "track_title";
		String TRACK_WAVEFORM_URL = "track_waveform_url";
		String TRACK_FAVOURITE = "track_favourite"; 
		
		String [] COLUMNS = new String [] { _ID, ALBUM_ID, ALBUM_DESCRIPTION, ALBUM_SLUG, ALBUM_TITLE, 
											TRACK_ID, TRACK_DOWNLOAD_URL, TRACK_PLAYBACK_COUNT, TRACK_LIKE_COUNT,
											TRACK_SLUG, TRACK_TITLE, TRACK_DESCRIPTION, TRACK_DOWNLOAD_URL, 
											TRACK_WAVEFORM_URL };		
	}
	
	public interface References
	{
		String ALBUM_ID = " REFERENCES " + Tables.ALBUMS + "(" + AlbumsColumns.ALBUM_ID + ") ON DELETE CASCADE";
	}
	
	public interface Index
	{
		String ALBUM_ID_INDEX = "album_id_index";
		String TRACK_ID_INDEX = "track_id_index";
	}
}
