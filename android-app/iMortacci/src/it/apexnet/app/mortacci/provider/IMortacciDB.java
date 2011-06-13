package it.apexnet.app.mortacci.provider;
import it.apexnet.app.mortacci.library.Album;
import it.apexnet.app.mortacci.library.Track;
import it.apexnet.app.mortacci.provider.IMortacciDBContract.FavouriteTracksViewColumns;
import it.apexnet.app.mortacci.provider.IMortacciDBContract.Index;
import it.apexnet.app.mortacci.provider.IMortacciDBContract.References;
import it.apexnet.app.mortacci.provider.IMortacciDBContract.Tables;
import it.apexnet.app.mortacci.provider.IMortacciDBContract.Views;
import android.content.Context;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.provider.BaseColumns;
import android.util.Log;

/**
 * Helper for managing {@link SQLiteDatabase} that stores data for
 * {@link IMortacciDBProvider}.
 */

public class IMortacciDB extends SQLiteOpenHelper {

	private static final String TAG = "IMortacciDB";
	private static final String DATABASE_NAME = "IMortacciDB.db";
	
	private static int DATABASE_VERSION = 1;
	
	
	public IMortacciDB(Context context) {
		super(context, DATABASE_NAME, null, DATABASE_VERSION);		
		// TODO Auto-generated constructor stub
	}


	@Override
	public void onCreate(SQLiteDatabase db) {
		// TODO Auto-generated method stub
		Log.i(TAG, "Start creating db");
		
		db.execSQL("CREATE TABLE " + Tables.ALBUMS + " ("
				+ BaseColumns._ID + " INTEGER PRIMARY KEY AUTOINCREMENT,"
				+ Album.ALBUM_ID + " INTEGER NOT NULL,"
				+ Album.DESCRIPTION + " TEXT,"
				+ Album.SLUG + " TEXT,"
				+ Album.STATUS + " INTEGER,"
				+ Album.TITLE + " TEXT )");
		
		
		db.execSQL("CREATE TABLE " + Tables.TRACKS + " ("
				+ BaseColumns._ID + " INTEGER PRIMARY KEY AUTOINCREMENT,"
				+ Track.ALBUM_ID + " INTEGER NOT NULL CONSTRAINT " + Track.FK_ALBUM_ID + References.ALBUM_ID + ","
				+ Track.DOWNLOAD_URL + " TEXT,"
				+ Track.TRACK_ID + " INTEGER NOT NULL,"
				+ Track.LIKE_COUNT + " INTEGER,"
				+ Track.PLAYBACK_COUNT + " INTEGER,"
				+ Track.SLUG + " TEXT,"
				+ Track.DESCRIPTION + " TEXT,"
				+ Track.STATUS + " INTEGER,"
				+ Track.TITLE + " TEXT,"
				+ Track.WAVEFORM_URL + " TEXT,"
				+ Track.FAVOURITE + " INTEGER NOT NULL DEFAULT (0) CHECK(" + Track.FAVOURITE + " IN (0,1)) )");
				
		
		db.execSQL("CREATE VIEW " + Views.FAVOURITE_TRACKS_VIEW + " AS " +
				"SELECT " 
				+ Tables.TRACKS + "." + "_id" + " AS " + "" + FavouriteTracksViewColumns._ID + ","			
				+ Tables.ALBUMS + "." + Album.DESCRIPTION + " AS " + FavouriteTracksViewColumns.ALBUM_DESCRIPTION + ","
				+ Tables.ALBUMS + "." + Album.ALBUM_ID + " AS " + FavouriteTracksViewColumns.ALBUM_ID + ","
				+ Tables.ALBUMS + "." + Album.SLUG + " AS " + FavouriteTracksViewColumns.ALBUM_SLUG + ","
				+ Tables.ALBUMS + "." + Album.STATUS + " AS " + FavouriteTracksViewColumns.ALBUM_STATUS + ","
				+ Tables.ALBUMS + "." + Album.TITLE + " AS " + FavouriteTracksViewColumns.ALBUM_TITLE + ","
				+ Tables.TRACKS + "." + Track.DOWNLOAD_URL + " AS " + FavouriteTracksViewColumns.TRACK_DOWNLOAD_URL + ","
				+ Tables.TRACKS + "." + Track.TRACK_ID + " AS " + FavouriteTracksViewColumns.TRACK_ID + ","
				+ Tables.TRACKS + "." + Track.LIKE_COUNT + " AS " + FavouriteTracksViewColumns.TRACK_LIKE_COUNT + ","
				+ Tables.TRACKS + "." + Track.PLAYBACK_COUNT + " AS " + FavouriteTracksViewColumns.TRACK_PLAYBACK_COUNT + ","
				+ Tables.TRACKS + "." + Track.SLUG + " AS " + FavouriteTracksViewColumns.TRACK_SLUG + ","
				+ Tables.TRACKS + "." + Track.DESCRIPTION + " AS " + FavouriteTracksViewColumns.TRACK_DESCRIPTION + ","
				+ Tables.TRACKS + "." + Track.STATUS + " AS " + FavouriteTracksViewColumns.TRACK_STATUS + ","
				+ Tables.TRACKS + "." + Track.TITLE + " AS " + FavouriteTracksViewColumns.TRACK_TITLE + ","
				+ Tables.TRACKS + "." + Track.WAVEFORM_URL + " AS " + FavouriteTracksViewColumns.TRACK_WAVEFORM_URL + ","
				+ Tables.TRACKS + "." + Track.FAVOURITE + " AS " + FavouriteTracksViewColumns.TRACK_FAVOURITE 
				+ " FROM " + Tables.ALBUMS + " INNER JOIN " + Tables.TRACKS + " ON "
				+ Tables.ALBUMS + "." + Album.ALBUM_ID + "=" + Tables.TRACKS + "." + Track.ALBUM_ID
				+ " WHERE " + Tables.TRACKS + "." + Track.FAVOURITE + "=1");
				 
				
				
		
		db.execSQL("CREATE UNIQUE INDEX " + Index.ALBUM_ID_INDEX + " ON " + Tables.ALBUMS + " (" + Album.ALBUM_ID + " Asc)");
		
		db.execSQL("CREATE UNIQUE INDEX " + Index.TRACK_ID_INDEX + " ON " + Tables.TRACKS + " (" + Track.TRACK_ID + " Asc)");
		
	}

	@Override
	public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
		// TODO Auto-generated method stub
		Log.i(TAG, "upgrade not implemented yet");
	}

	
}
