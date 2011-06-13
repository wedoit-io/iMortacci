package it.apexnet.app.mortacci.ui;

import it.apexnet.app.mortacci.R;
import it.apexnet.app.mortacci.library.Track;
import it.apexnet.app.mortacci.provider.FavouriteTracksRowAdapter;
import it.apexnet.app.mortacci.provider.IMortacciDBContract.FavouriteTracksViewColumns;
import it.apexnet.app.mortacci.provider.IMortacciDBContract.Views;
import it.apexnet.app.mortacci.provider.IMortacciDBProvider;
import it.apexnet.app.mortacci.util.UIUtils;
import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Intent;
import android.database.Cursor;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.ImageButton;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ListView;

import com.google.ads.Ad;
import com.google.ads.AdListener;
import com.google.ads.AdRequest.ErrorCode;

public class FavouriteTracksActivity extends Activity implements AdListener{

	private static String TAG = "FavouriteTracksActivity";
	private FavouriteTracksRowAdapter adapter;
	private Cursor cursor;
	private IMortacciDBProvider db;
	private ListView trackList;	
	
	@Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        
        setContentView(R.layout.activity_favourite_tracks);
             
        try
        {
	        new CreateFavouriteListTracksSync().execute((Void []) null);
	        
	        this.trackList = (ListView) findViewById(R.id.favouriteTracksListView);       
	        	        
	        ImageButton homeButton = (ImageButton)findViewById(R.id.home_image_button);
			homeButton.setOnClickListener(new OnClickListener()
			{
				public void onClick(View arg0) {
					onHomeClick();
				}
				
			});
        }
        catch (Exception ex)
        {}
	}
	
	private void onHomeClick ()
    {
    	UIUtils.goHome(this);
    }
	
	private class CreateFavouriteListTracksSync extends AsyncTask<Void, Void, Void>
	{

		private final ProgressDialog dialog = new ProgressDialog(FavouriteTracksActivity.this);
		
		@Override
		protected void onPreExecute() {			
            this.dialog.show();		            
		}
		
		@Override
		protected Void doInBackground(Void... params) {
			// TODO Auto-generated method stub
			db = new IMortacciDBProvider(FavouriteTracksActivity.this);
			cursor = db.query(false, Views.FAVOURITE_TRACKS_VIEW, FavouriteTracksViewColumns.COLUMNS , null, null, null, null, null, null);						
			
			return null;
		}
		
		@Override
		protected void onPostExecute (Void x)
		{
			adapter = new FavouriteTracksRowAdapter(FavouriteTracksActivity.this, cursor);
			trackList.setAdapter(adapter);
			
			trackList.setOnItemClickListener(new OnItemClickListener() {

				public void onItemClick(AdapterView<?> parent, View view,
						int position, long id) {
					// TODO Auto-generated method stub
					Cursor c = ((FavouriteTracksRowAdapter)parent.getAdapter()).getCursor();
					Track track = new Track();
					
					track.album_ID = c.getInt(
							c.getColumnIndex(FavouriteTracksViewColumns.ALBUM_ID));
					
					track.ID = c.getInt(
							c.getColumnIndex(FavouriteTracksViewColumns.TRACK_ID));
					
					track.slug = c.getString(
							c.getColumnIndex(FavouriteTracksViewColumns.TRACK_SLUG));
								
					track.title =  c.getString(
							c.getColumnIndex(FavouriteTracksViewColumns.TRACK_TITLE));
						
					track.description = c.getString(
							c.getColumnIndex(FavouriteTracksViewColumns.TRACK_DESCRIPTION));
					
					track.playbackCount = c.getInt(
							c.getColumnIndex(FavouriteTracksViewColumns.TRACK_PLAYBACK_COUNT));
					
					track.likeCount = c.getInt(
							c.getColumnIndex(FavouriteTracksViewColumns.TRACK_LIKE_COUNT));
					
					track.downloadURL = c.getString(
							c.getColumnIndex(FavouriteTracksViewColumns.TRACK_DOWNLOAD_URL));
					
					track.waveformURL = c.getString(
							c.getColumnIndex(FavouriteTracksViewColumns.TRACK_WAVEFORM_URL));
					
					track.slugAlbum = c.getString(
							c.getColumnIndex(FavouriteTracksViewColumns.ALBUM_SLUG));
					
					Bundle bundle = new Bundle();
					bundle.putSerializable("Track", track);
					Intent intent = new Intent(FavouriteTracksActivity.this, PlayTrackActivity.class);
					intent.putExtras(bundle);
					startActivity(intent);
				}
				
			});
			
			if(this.dialog.isShowing())
                this.dialog.dismiss();
		}	
	}
	
	public void onDismissScreen(Ad arg0) {
		// TODO Auto-generated method stub
		
	}

	public void onFailedToReceiveAd(Ad arg0, ErrorCode arg1) {
		// TODO Auto-generated method stub
		
	}

	public void onLeaveApplication(Ad arg0) {
		// TODO Auto-generated method stub
		
	}

	public void onPresentScreen(Ad arg0) {
		// TODO Auto-generated method stub
		
	}

	public void onReceiveAd(Ad arg0) {
		// TODO Auto-generated method stub
		
	}

	@Override
	protected void onDestroy()
	{
		super.onDestroy();
		this.cursor.close();
		this.db.close();
	}
	
}
