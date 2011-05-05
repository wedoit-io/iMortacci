package it.apexnet.app.mortacci.ui;

import java.io.IOException;

import com.google.ads.AdRequest;
import com.google.ads.AdSize;

import it.apexnet.app.mortacci.R;
import it.apexnet.app.mortacci.library.Track;
import it.apexnet.app.mortacci.util.UIUtils;
import it.apexnet.app.mortacci.widget.AdViewLoader;
import it.apexnet.app.mortacci.widget.MyMediaPlayer;
import android.app.Activity;
import android.app.ProgressDialog;
import android.media.AudioManager;
import android.media.MediaPlayer;
import android.media.MediaPlayer.OnCompletionListener;
import android.media.MediaPlayer.OnPreparedListener;
import android.net.ConnectivityManager;
import android.os.Bundle;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

public class PlayTrackActivity extends Activity implements Runnable{

	private static String TAG = "PlayTrackActivity";
	
	private String urlMp3Streaming;
	private MyMediaPlayer mp;
	private boolean newInstancePlayer;
	private boolean isPreparedMediaPlayer;
	private ProgressDialog progDialog;
	private MediaPlayerThread mediaPlayerThread;
	
	@Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        
        setContentView(R.layout.activity_play_track);
        
        this.progDialog = new ProgressDialog(this);
        
        setVolumeControlStream(AudioManager.STREAM_MUSIC);
        
        ImageButton playButton = (ImageButton)findViewById (R.id.play_btn_img);
		ImageView trackImage = (ImageView)findViewById (R.id.image_preview);		
		
        ConnectivityManager conn = (ConnectivityManager)getSystemService(Activity.CONNECTIVITY_SERVICE);
		if (conn.getActiveNetworkInfo() != null && conn.getActiveNetworkInfo().isConnected())
		{
			try
			{
				mp = null;
				Bundle bundle = getIntent().getExtras();
				
				Track track = (Track)bundle.get("Track");
				track.setImgAlbum (trackImage);
				
				((TextView) findViewById(R.id.title_text)).setText(track.title);
				
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
					if (!isPreparedMediaPlayer )
						progDialog.show();
					}
					catch (Exception e)
					{
						Log.e(TAG, "error prog dialog");
						progDialog.dismiss();
					}
					//MediaPlayer mp = MediaPlayer.create(PlayTrackActivity.this, R.raw.file1);
				    //mp.start();
					
					try
					{
						Log.i(TAG, "try to start media player");
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
			}
			catch (Exception e)
			{
				Toast.makeText(this, "No connection", Toast.LENGTH_SHORT).show();
			}
		}
		else
		{
			Toast.makeText(this, "No connection", Toast.LENGTH_SHORT).show();
		}
		
		ImageButton homeButton = (ImageButton)findViewById(R.id.home_image_button);
		homeButton.setOnClickListener(new OnClickListener()
		{
			public void onClick(View arg0) {
				onHomeClick();
			}
			
		});
		
		// Create the adView
		AdViewLoader adView = new AdViewLoader(this, AdSize.BANNER);			    
	    // Lookup your LinearLayout assuming it’s been given
	    // the attribute android:id="@+id/mainLayout"
	    LinearLayout layout = (LinearLayout)findViewById(R.id.banner_layout);
	    // Add the adView to it
	    AdRequest request = new AdRequest();	    
	    adView.setGravity(Gravity.BOTTOM);
    	layout.addView(adView);		    	
	    adView.loadAd(request);
	}		

	public void run() {
		// TODO Auto-generated method stub
		
	}		
	
	private void onHomeClick ()
    {
    	UIUtils.goHome(this);
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
						mp.setDataSource(urlMp3Streaming);
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
