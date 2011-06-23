package it.apexnet.app.mortacci.ui;

import it.apexnet.app.mortacci.R;
import it.apexnet.app.mortacci.library.Track;
import it.apexnet.app.mortacci.provider.FavouriteTracksRowAdapter;
import it.apexnet.app.mortacci.provider.IMortacciDBContract.FavouriteTracksViewColumns;
import it.apexnet.app.mortacci.provider.IMortacciDBContract.Tables;
import it.apexnet.app.mortacci.provider.IMortacciDBContract.Views;
import it.apexnet.app.mortacci.provider.IMortacciDBProvider;
import it.apexnet.app.mortacci.util.MediaUtil;
import it.apexnet.app.mortacci.util.UIUtils;
import it.apexnet.app.mortacci.widget.AdViewLoader;
import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Intent;
import android.database.Cursor;
import android.os.AsyncTask;
import android.os.Bundle;
import android.util.Log;
import android.view.ContextMenu;
import android.view.ContextMenu.ContextMenuInfo;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.AdapterView.AdapterContextMenuInfo;
import android.widget.ImageButton;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ListView;
import com.google.android.apps.analytics.GoogleAnalyticsTracker;

import com.google.ads.Ad;
import com.google.ads.AdListener;
import com.google.ads.AdRequest;
import com.google.ads.AdSize;
import com.google.ads.AdRequest.ErrorCode;

public class FavouriteTracksActivity extends Activity implements AdListener{

	private final static int DELETE_MENU_OPTION = 1;
	
	private static String TAG = "/FavouriteTracksActivity";
	private FavouriteTracksRowAdapter adapter;
	private Cursor cursor;
	private IMortacciDBProvider db;
	private ListView trackList;	
	
	GoogleAnalyticsTracker tracker;
	
	@Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        
        setContentView(R.layout.activity_favourite_tracks);
        ((TextView) findViewById(R.id.title_text)).setText(getTitle());
        
        this.tracker = GoogleAnalyticsTracker.getInstance();
        
        try
        {
        	this.tracker.start(getResources().getString(R.string.analyticsUACode), 5, this);
        	this.tracker.trackPageView(TAG);
        	
	        new CreateFavouriteListTracksSync().execute((Void []) null);
	        
	        this.trackList = (ListView) findViewById(R.id.favouriteTracksListView);       
	        registerForContextMenu(this.trackList);	        
        }
        catch (Exception ex)
        {
        	Log.e(TAG, "error");
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
	    LinearLayout layout = (LinearLayout)findViewById(R.id.root_linear_layout);
	    // Add the adView to it
	    AdRequest request = new AdRequest();	       
    	layout.addView(adView);		    	
	    adView.loadAd(request);
	}
	
	private void onHomeClick ()
    {
    	UIUtils.goHome(this);
    }
	
	
	@Override
	protected void onRestart()
	{
		super.onRestart();
		updateListView();		
	}
	
	@Override
	public void onCreateContextMenu(ContextMenu menu, View v,
			ContextMenuInfo menuInfo) {
		// Creiamo il Menu da associare all'item
		int group = Menu.FIRST;
		menu.add(group, DELETE_MENU_OPTION, Menu.FIRST, R.string.cancelOption);		
	}
	
	@Override
	public boolean onContextItemSelected(MenuItem item) {
		AdapterContextMenuInfo info = (AdapterContextMenuInfo) item
				.getMenuInfo();
		long trackId = info.id;
		Cursor cursorFileName = db.query(true, Tables.TRACKS, new String[] {"track_id", "_id"}, "_id=?", new String[] {Long.toString(trackId)}, null, null, null, null);
		
		int IdTrackName = 0;
		while (cursorFileName.moveToNext())			
			IdTrackName  = cursorFileName.getInt(cursorFileName.getColumnIndex("track_id"));
		
		String fileName = Integer.toString(IdTrackName) + ".mp3";
		
		cursorFileName.close();
		
		switch (item.getItemId()) {
			case DELETE_MENU_OPTION:
			try {
				MediaUtil.FileTrackOnExternalStorageDelete(FavouriteTracksActivity.this, fileName);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
				db.delete(Tables.TRACKS, "_id=" + trackId, null);
				updateListView();
				return true;				
			default:
				return super.onContextItemSelected(item);
		}
	}

	
	private void updateListView() {
		// Diciamo al Cursor di rieseguire la query
		if (cursor != null)
			cursor.requery();
		// Notifichiamo le View associte agli adapter di fare il refresh
		if (adapter != null)
			adapter.notifyDataSetChanged();
	}
	
	private class CreateFavouriteListTracksSync extends AsyncTask<Void, Void, Void>
	{

		private final ProgressDialog dialog = new ProgressDialog(FavouriteTracksActivity.this);
		
		@Override
		protected void onPreExecute() {		
			if (this.dialog != null)
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
			try
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
						
						final String albumTitle = c.getString(
								c.getColumnIndex(FavouriteTracksViewColumns.ALBUM_TITLE));
						
						final String albumDescription = c.getString(
								c.getColumnIndex(FavouriteTracksViewColumns.ALBUM_DESCRIPTION));
						
						final String albumSlug = c.getString(
								c.getColumnIndex(FavouriteTracksViewColumns.ALBUM_SLUG));
						
						final int albumID = c.getInt(
								c.getColumnIndex(FavouriteTracksViewColumns.ALBUM_ID));
						
						
						Bundle bundle = new Bundle();
						bundle.putSerializable("Track", track);
						bundle.putString("album_title", albumTitle);
						bundle.putInt("album_id", albumID);
						bundle.putString("album_description", albumDescription);
						bundle.putString("album_slug", albumSlug);
						Intent intent = new Intent(FavouriteTracksActivity.this, PlayTrackActivity.class);
						intent.putExtras(bundle);
						
						tracker.trackEvent("Track", "view", track.title, 20);
						
						startActivity(intent);
					}
					
				});
				
				if(this.dialog != null && this.dialog.isShowing())
				{				
					this.dialog.dismiss();				
				}
			}
			catch (Exception ex)
			{
				Log.e(TAG, "Error");
			}
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
		
		this.tracker.dispatch();		
		this.tracker.stop();
		
		if (this.cursor != null)
			this.cursor.close();
		if (this.db != null)
			this.db.close();
	}
	
}
