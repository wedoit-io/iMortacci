package it.apexnet.app.mortacci.ui;

import java.io.IOException;

import it.apexnet.app.mortacci.R;
import it.apexnet.app.mortacci.library.Album;
import it.apexnet.app.mortacci.library.Track;
import it.apexnet.app.mortacci.widget.MyMediaPlayer;
import android.app.Activity;
import android.media.MediaPlayer;
import android.media.MediaPlayer.OnPreparedListener;
import android.net.ConnectivityManager;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

public class PlayTrackActivity extends Activity{

	private String urlMp3Streaming;
	private MyMediaPlayer mp;
	private boolean newInstancePlayer;
	private boolean isPreparedMediaPlayer;
	
	@Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        
        setContentView(R.layout.activity_play_track);
        
        
        Button buttonMatches = (Button)findViewById (R.id.play_btn_img);
		ImageView trackImage = (ImageView)findViewById (R.id.image_preview);		
		
        ConnectivityManager conn = (ConnectivityManager)getSystemService(Activity.CONNECTIVITY_SERVICE);
		if (conn.getActiveNetworkInfo() != null && conn.getActiveNetworkInfo().isConnected())
		{
			mp = null;
			Bundle bundle = getIntent().getExtras();
			
			Track track = (Track)bundle.get("Track");
			setImgAlbum (track , trackImage);
			
			((TextView) findViewById(R.id.title_text)).setText(track.title);
			
			((TextView) findViewById(R.id.title_track)).setText(track.title);
			((TextView) findViewById(R.id.description_track)).setText(track.description);			
			
			this.urlMp3Streaming = "http://api.soundcloud.com/tracks/" + Integer.toString(track.ID) + "/stream?client_id=7Eo3B0odlpK5FvOVUKDnQ";
			this.newInstancePlayer = true;
			mp = MyMediaPlayer.getMyMediaPlayer(newInstancePlayer);
			
			buttonMatches.setOnClickListener(new OnClickListener(){
			public void onClick(View arg0) {
				//MediaPlayer mp = MediaPlayer.create(PlayTrackActivity.this, R.raw.file1);
			    //mp.start();
				isPreparedMediaPlayer = false;
				
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
				int waited = 0;
				int timeWaiting = 3000;
				/*while (!isPreparedMediaPlayer && (waited < timeWaiting))
				{
					try {
						Thread.sleep(10);
					} catch (InterruptedException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
					waited += 100;
				}*/
				
				mp.start();
				newInstancePlayer = false;
			}
		 });
			
			this.mp.setOnPreparedListener(new OnPreparedListener()
			{
				public void onPrepared(MediaPlayer mp)
				{
					isPreparedMediaPlayer = true;
				}
			});
		}
	}
		 
	private void setImgAlbum (Track t, ImageView i)
	{
		if (t.slugAlbum.equalsIgnoreCase("calabria"))
			i.setImageResource(R.drawable.calabria);
		else if (t.slugAlbum.equalsIgnoreCase("campania"))
			i.setImageResource(R.drawable.campania);
		else if (t.slugAlbum.equalsIgnoreCase("puglia"))
			i.setImageResource(R.drawable.puglia);
		else if (t.slugAlbum.equalsIgnoreCase("lazio"))
			i.setImageResource(R.drawable.lazio);
		else if (t.slugAlbum.equalsIgnoreCase("toscana"))
			i.setImageResource(R.drawable.toscana);
		else if (t.slugAlbum.equalsIgnoreCase("veneto"))
			i.setImageResource(R.drawable.veneto);
		else if (t.slugAlbum.equalsIgnoreCase("emiliaromagna"))
			i.setImageResource(R.drawable.emiliaromagna);
		else if (t.slugAlbum.equalsIgnoreCase("sardegna"))
			i.setImageResource(R.drawable.sardegna);
		else if (t.slugAlbum.equalsIgnoreCase("sicilia"))
			i.setImageResource(R.drawable.sicilia);		
		else
			i.setImageResource(R.drawable.default_img);
		
	}
}
