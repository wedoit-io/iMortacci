package it.apexnet.app.mortacci.ui;

import java.io.File;
import java.io.IOException;

import com.google.ads.AdRequest;
import com.google.ads.AdSize;

import it.apexnet.app.mortacci.R;
import it.apexnet.app.mortacci.library.Album;
import it.apexnet.app.mortacci.library.Track;
import it.apexnet.app.mortacci.provider.IMortacciDBContract.FavouriteTracksViewColumns;
import it.apexnet.app.mortacci.provider.IMortacciDBContract.Tables;
import it.apexnet.app.mortacci.provider.IMortacciDBContract.Views;
import it.apexnet.app.mortacci.provider.IMortacciDBProvider;
import it.apexnet.app.mortacci.util.MediaUtil;
import it.apexnet.app.mortacci.util.UIUtils;
import it.apexnet.app.mortacci.widget.AdViewLoader;
import it.apexnet.app.mortacci.widget.MyMediaPlayer;
import android.app.Activity;
import android.app.ProgressDialog;
import android.content.ContentValues;
import android.content.Intent;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.media.AudioManager;
import android.media.MediaPlayer;
import android.media.MediaPlayer.OnCompletionListener;
import android.media.MediaPlayer.OnPreparedListener;
import android.net.ConnectivityManager;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Environment;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;
import com.google.android.apps.analytics.GoogleAnalyticsTracker;

public class PlayTrackActivity extends Activity implements Runnable{

	enum FavouriteResult
	{
		noSDMounted,
		noConnectionNoMortaccione,
		mortaccioneGiaPreferito,
		Yeah
	}
	
	GoogleAnalyticsTracker tracker;
	
	private static String TAG = "/PlayTrackActivity";
	
	private String urlMp3Streaming;
	private String urlMp3Downloading;
	private MyMediaPlayer mp;
	private boolean newInstancePlayer;
	private boolean isPreparedMediaPlayer;
	private ProgressDialog progDialog;
	private MediaPlayerThread mediaPlayerThread;
	private IMortacciDBProvider db;
	private Track track;
	private boolean isFavouriteTrack = false;
	
	@Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        
        setContentView(R.layout.activity_play_track);
        
        this.tracker = GoogleAnalyticsTracker.getInstance();
        
        this.progDialog = new ProgressDialog(this);
        
        setVolumeControlStream(AudioManager.STREAM_MUSIC);
        
        this.tracker.start(getResources().getString(R.string.analyticsUACode), 5, this);
        
        ImageButton playButton = (ImageButton)findViewById (R.id.play_btn_img);
		ImageView trackImage = (ImageView)findViewById (R.id.image_preview);		
		ImageButton shareButton = (ImageButton)findViewById(R.id.share_btn_img);
		ImageButton favouriteButton = (ImageButton)findViewById(R.id.favourite_btn_img);
		
		final Bundle bundle = getIntent().getExtras();
		this.track = (Track)bundle.get("Track");
		
		this.db = new IMortacciDBProvider(this);
		
		Cursor cursor = this.db.query(false, Views.FAVOURITE_TRACKS_VIEW, new String[] {FavouriteTracksViewColumns._ID} , FavouriteTracksViewColumns.TRACK_ID +"=?",new String[] {Integer.toString(track.ID)}, null, null, null, null);
		this.isFavouriteTrack = cursor.getCount() != 0;
		cursor.close();		
        
		this.tracker.trackPageView(TAG);
		
		try
		{
			mp = null;
			this.track.setImgAlbum (trackImage);			
			
			((TextView) findViewById(R.id.title_text)).setText(((String)bundle.get("album_title")));
			
			((TextView) findViewById(R.id.title_track)).setText(track.title);
			((TextView) findViewById(R.id.description_track)).setText(track.description);			
			
			this.mediaPlayerThread = new MediaPlayerThread();
			this.urlMp3Streaming = getResources().getString(R.string.apiSoundCloudURL) + Integer.toString(track.ID) + getResources().getString(R.string.apiSoundCloudStreamID);				
			this.newInstancePlayer = true;
			
			mp = MyMediaPlayer.getMyMediaPlayer(newInstancePlayer);
			
			playButton.setOnClickListener(new OnClickListener(){
			public void onClick(View arg0) {
				
				try
				{					
				if (!isPreparedMediaPlayer && progDialog != null)
					progDialog.show();
				}
				catch (Exception e)
				{
					Log.e(TAG, "error prog dialog");
					if (progDialog != null && progDialog.isShowing())
						progDialog.dismiss();
				}
				
				try
				{
					Log.i(TAG, "trying to start media player");		
					tracker.trackEvent("Track", "play", track.title, 50);
					mediaPlayerThread.start();
				}
				catch (Exception ex)
				{
					Log.e(TAG, ex.getMessage());
				}
				
				newInstancePlayer = false;		
			}
		 });
			
			this.mp.setOnPreparedListener(new OnPreparedListener()
			{
				public void onPrepared(MediaPlayer mp)
				{
					if (progDialog != null && progDialog.isShowing())
						progDialog.dismiss();
					isPreparedMediaPlayer = true;
					Log.i(TAG, "media player prepared");
				}
			});
			
			
			this.mp.setOnCompletionListener(new OnCompletionListener()
			{

				public void onCompletion(MediaPlayer mp) {
					// TODO Auto-generated method stub
					Log.i(TAG, "on completion media player");
					mp.reset();
					isPreparedMediaPlayer = false;
					if (mediaPlayerThread != null)
						mediaPlayerThread.stop();
				}
				
			});
			
			
			shareButton.setOnClickListener(new OnClickListener()
			{

				public void onClick(View v) {
					// TODO Auto-generated method stub
					try
					{
						tracker.trackEvent("Track", "share", track.title, 40);
						UIUtils.share(track.title, track.description, "http://www.imortacci.com/it/player/" + track.ID, PlayTrackActivity.this);
					}
					catch (Exception ex)
					{}
				}
				
			});
							
			
			favouriteButton.setOnClickListener (new OnClickListener() {
				
				public void onClick(View v) {
					// TODO Auto-generated method stub
					try
					{		
						tracker.trackEvent("Track", "add to Favourite", track.title, 30);
						new FavouriteSync().execute(bundle);
					}
					catch (Exception ex)
					{}						
				}
			});
		}
		catch (Exception e)
		{
			//Toast.makeText(this, "No connection", Toast.LENGTH_SHORT).show();
		}		
		
		ImageButton homeButton = (ImageButton)findViewById(R.id.home_image_button);
		homeButton.setOnClickListener(new OnClickListener()
		{
			public void onClick(View arg0) {
				onHomeClick();
			}
			
		});
		
		ImageButton favouriteActivityButton = (ImageButton)findViewById(R.id.favourite_image_button);
		favouriteActivityButton.setOnClickListener(new OnClickListener()
		{
			public void onClick(View arg0) {								
				startActivity(new Intent(PlayTrackActivity.this, FavouriteTracksActivity.class));
			}
			
		});
		
		// Create the adView
		AdViewLoader adView = new AdViewLoader(this, AdSize.BANNER);			    
	    // Lookup your LinearLayout assuming it�s been given
	    // the attribute android:id="@+id/mainLayout"	
	    LinearLayout layout = (LinearLayout)findViewById(R.id.banner_layout);
	    layout.setGravity(Gravity.BOTTOM);
	    // Add the adView to it
	    AdRequest request = new AdRequest();	    
	    adView.setGravity(Gravity.BOTTOM);
    	layout.addView(adView);		    	
	    adView.loadAd(request);
	}			
	
	@Override
	protected void onRestart()
	{
		try
		{
		super.onRestart();
		this.db = new IMortacciDBProvider(this);
		
		Cursor cursor = this.db.query(false, Views.FAVOURITE_TRACKS_VIEW, new String[] {FavouriteTracksViewColumns._ID} , FavouriteTracksViewColumns.TRACK_ID +"=?",new String[] {Integer.toString(track.ID)}, null, null, null, null);
		this.isFavouriteTrack = cursor.getCount() != 0;
		cursor.close();
		}
		catch(Exception ex)
		{}
	}
	
	@Override
	public void onDestroy()
	{
		super.onDestroy();	
		
		this.tracker.dispatch();		
		this.tracker.stop();
		
		this.db.close();
	}
	
	@Override
	public void onStop()
	{
		super.onStop();		
		if (this.progDialog != null && this.progDialog.isShowing())
			this.progDialog.dismiss();
		
		if (mediaPlayerThread != null)
			mediaPlayerThread.stop();
	}
	
	public void run() {
		// TODO Auto-generated method stub
		
	}		
	
	private void onHomeClick ()
    {
    	UIUtils.goHome(this);
    }
	
	private class FavouriteSync extends AsyncTask<Bundle, Void, FavouriteResult>
	{

		private final ProgressDialog dialog = new ProgressDialog(PlayTrackActivity.this);
		
		@Override
		protected void onPreExecute() {
			this.dialog.setMessage(getResources().getString(R.string.downloading));
            this.dialog.show();		            
		}
		
		@Override
		protected FavouriteResult doInBackground(Bundle... bundles) {
			// TODO Auto-generated method stub
			
			final SQLiteDatabase database = db.getWritableDatabase();
			FavouriteResult result = FavouriteResult.Yeah;
			
			for (Bundle bundle : bundles)
			{
				database.beginTransaction();
				try
				{
					
					if (! isFavouriteTrack)
					{					
						final String albumTitle = (String)bundle.get("album_title");
						final int albumId = (Integer)bundle.get("album_id");
						final String albumDescription = (String)bundle.get("album_description");
						final String albumSlug = (String)bundle.get("album_slug");
						
						ContentValues cValuesAlbum = new ContentValues();
						cValuesAlbum.put(Album.ALBUM_ID, albumId);
						cValuesAlbum.put(Album.DESCRIPTION, albumDescription);
						cValuesAlbum.put(Album.SLUG, albumSlug);
						cValuesAlbum.put(Album.TITLE, albumTitle);
						database.insert(Tables.ALBUMS, Album.DESCRIPTION, cValuesAlbum);
						
						ContentValues cValuesTracks = new ContentValues();
						cValuesTracks.put(Track.ALBUM_ID, albumId);
						cValuesTracks.put(Track.DOWNLOAD_URL, track.downloadURL);
						cValuesTracks.put(Track.TRACK_ID, track.ID);
						cValuesTracks.put(Track.LIKE_COUNT, track.likeCount);
						cValuesTracks.put(Track.PLAYBACK_COUNT, track.playbackCount);
						cValuesTracks.put(Track.SLUG, track.slug);
						cValuesTracks.put(Track.TITLE, track.title);
						cValuesTracks.put(Track.DESCRIPTION, track.description);
						cValuesTracks.put(Track.WAVEFORM_URL, track.waveformURL);
						cValuesTracks.put(Track.FAVOURITE, 1);
						database.insert(Tables.TRACKS, Track.TITLE, cValuesTracks);	
						
						String state = Environment.getExternalStorageState();
						ConnectivityManager conn = (ConnectivityManager)getSystemService(Activity.CONNECTIVITY_SERVICE);
						if (conn.getActiveNetworkInfo() != null && conn.getActiveNetworkInfo().isConnected())
						{							
							// check if media is available, so i can read and write the media
							if (Environment.MEDIA_MOUNTED.equals(state))
							{
								urlMp3Downloading = getResources().getString(R.string.apiSoundCloudURL) + Integer.toString(track.ID) + getResources().getString(R.string.apiSoundCloudDownloadID);
								try {
									MediaUtil.createExternalStoragePrivateFileTrack(PlayTrackActivity.this, Integer.toString(track.ID) + ".mp3", urlMp3Downloading);
									database.setTransactionSuccessful();
									result = FavouriteResult.Yeah;
								} catch (Exception e) {
									// TODO Auto-generated catch block
									Log.e(TAG, "Error dowloading track from soundcloud");							
								}
							}
							else
							{
								result = FavouriteResult.noSDMounted;								
							}
						}
						else
						{
							result = FavouriteResult.noConnectionNoMortaccione;							
						}
							
					}
					else
						result = FavouriteResult.mortaccioneGiaPreferito;						
				}
				catch (Exception ex)
				{
					database.endTransaction();
					Log.e(TAG, ex.getMessage());
				}
				finally
				{
					database.endTransaction();
					database.close();
				}
			}
			return result;
		}
		
		@Override
		protected void onPostExecute(FavouriteResult result)
		{
			if(this.dialog.isShowing())
                this.dialog.dismiss();
			
			
			switch (result) {
				case noSDMounted:
					Toast.makeText(PlayTrackActivity.this, getResources().getString(R.string.noSDMounted),  Toast.LENGTH_SHORT).show();														
					break;
				case noConnectionNoMortaccione:
					Toast.makeText(PlayTrackActivity.this, getResources().getString(R.string.noConnectionNoMortaccione),  Toast.LENGTH_SHORT).show();
					break;
				case mortaccioneGiaPreferito:
					Toast.makeText(PlayTrackActivity.this,getResources().getString(R.string.mortaccioneGiaPreferito),  Toast.LENGTH_SHORT).show();
					break;	
				case Yeah:
					Toast.makeText(PlayTrackActivity.this,getResources().getString(R.string.mortaccioneScaricatoEPreferito),  Toast.LENGTH_SHORT).show();
					isFavouriteTrack = true;
					break;	
			default:
				break;
			}
		}
		
	}
	
	class MediaPlayerThread implements Runnable
	{

		private Thread mpThread;		
		
		public void start()
		{						
			this.mpThread = new Thread()
			{
				@Override
				public void run() {
					
					Log.i(TAG, "run mpThread");
					// TODO Auto-generated method stub
					try {
						if (! isFavouriteTrack)
						{
							ConnectivityManager conn = (ConnectivityManager)getSystemService(Activity.CONNECTIVITY_SERVICE);
							if (conn.getActiveNetworkInfo() != null && conn.getActiveNetworkInfo().isConnected())
							{
								mp.setDataSource(urlMp3Streaming);
							}
							else
							{
								Toast.makeText(PlayTrackActivity.this, "No connection", Toast.LENGTH_SHORT).show();
								if (progDialog != null && progDialog.isShowing())
									progDialog.dismiss();
							}
						}
						else
						{
							//
							File file = new File(getExternalFilesDir(Environment.DIRECTORY_MUSIC), Integer.toString(track.ID)+ ".mp3");
							Log.i(TAG, file.getPath());
							mp.setDataSource(file.getPath());
						}
					} catch (IllegalArgumentException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					} catch (IllegalStateException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					} catch (IOException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
					
					try {
						mp.prepare();					
					} catch (IllegalStateException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					} catch (IOException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}					
					Log.i(TAG, "start media player");
					mp.start();		
				}
			};
			
			this.mpThread.start();
		}				
		
		public void stop()
		{
			if (this.mpThread != null)	
			{
				this.mpThread.interrupt();
				this.mpThread = null;
			}
		}

		public void run() {
			// TODO Auto-generated method stub
			
		}
	}
}
