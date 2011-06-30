package it.apexnet.app.mortacci.ui;

import com.google.ads.AdRequest;
import com.google.ads.AdSize;

import it.apexnet.app.mortacci.R;
import it.apexnet.app.mortacci.library.Album;
import it.apexnet.app.mortacci.library.Track;
import it.apexnet.app.mortacci.provider.TracksArrayAdapter;
import it.apexnet.app.mortacci.widget.AdViewLoader;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.media.AudioManager;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.inputmethod.InputMethodManager;
import android.widget.AdapterView;
import android.widget.ImageButton;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.AdapterView.OnItemClickListener;
import com.google.android.apps.analytics.GoogleAnalyticsTracker;

public class TrackActivity extends Activity{

	private static String TAG = "/TrackActivity";
	GoogleAnalyticsTracker tracker;
		
	@Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        
        setContentView(R.layout.activity_tracks);        
        
        final ListView listView = (ListView) findViewById(R.id.tracksListView);
        listView.setTextFilterEnabled(true);
        
        this.tracker = GoogleAnalyticsTracker.getInstance();
        
        setVolumeControlStream(AudioManager.STREAM_MUSIC);
        
        //ConnectivityManager conn = (ConnectivityManager)getSystemService(Activity.CONNECTIVITY_SERVICE);
        try
        {
		//if (conn.getActiveNetworkInfo() != null && conn.getActiveNetworkInfo().isConnected())
		//{
			
			this.tracker.start(getResources().getString(R.string.analyticsUACode), 5, this);
			Bundle bundle = getIntent().getExtras();
					
			
			final Album album = (Album)bundle.get("Album");
			((TextView) findViewById(R.id.title_text)).setText(album.title);
			
			this.tracker.trackPageView(TAG);
								
			
			TracksArrayAdapter arrayAdapter = new TracksArrayAdapter(this, album, (LayoutInflater)getSystemService(Context.LAYOUT_INFLATER_SERVICE));
			
			/*ArrayAdapter<Track> arrayAdapter = new ArrayAdapter<Track>(this,
					R.layout.list_item_tracks, R.id.title_track, trackList)
			{
				@Override
				public View getView (int position, View convertView, ViewGroup parent)
				{
					ViewHolder viewHolder = null;
					if (convertView == null)
					{
						LayoutInflater inflater = (LayoutInflater)getSystemService(Context.LAYOUT_INFLATER_SERVICE);
						convertView = inflater.inflate(R.layout.list_item_tracks, null);
						viewHolder = new ViewHolder();
						viewHolder.TrackTitleTextView = (TextView)convertView.findViewById(R.id.title_track);
						viewHolder.PlaybackCountTextView = (TextView)convertView.findViewById(R.id.playback_count);
						viewHolder.TrackImageView = (ImageView)convertView.findViewById(R.id.image_preview);
						convertView.setTag(viewHolder);
					}
					else
					{
						viewHolder = (ViewHolder)convertView.getTag();
					}
					Track item = getItem (position);
					viewHolder.TrackTitleTextView.setText(item.title);
					viewHolder.PlaybackCountTextView.setText(String.valueOf(item.playbackCount) + " ascolti");
					album.setImgAlbum(viewHolder.TrackImageView);
					return convertView;
				}				
			};
					*/	
			listView.setAdapter(arrayAdapter);
			
			listView.setOnItemClickListener(new OnItemClickListener()
			{
				
				public void onItemClick(AdapterView<?> parent, View view,
		    	        int position, long id)
				{
					Track t = new Track();
					t = ((Track)parent.getAdapter().getItem(position));
					Bundle bundle = new Bundle();			
					bundle.putSerializable("Track", t);
					bundle.putString("album_title", album.title);
					bundle.putInt("album_id", album.ID);
					bundle.putString("album_description", album.description);
					bundle.putString("album_slug", album.slug);					
					Intent intent = new Intent(TrackActivity.this, PlayTrackActivity.class);
					intent.putExtras(bundle);					
					
					tracker.trackEvent("Track", "view", t.title, 20);
					
					startActivity(intent);			
				}
			});		
		}
		/*else
		{
			Toast.makeText(this, "No connection", Toast.LENGTH_SHORT).show();			
		}
        }*/catch (Exception e)
        {
        	Toast.makeText(this, "No connection", Toast.LENGTH_SHORT).show();
        }               
        
		ImageButton favouriteButton = (ImageButton)findViewById(R.id.favourite_image_button);
		favouriteButton.setOnClickListener(new OnClickListener()
		{
			public void onClick(View arg0) {
				startActivity(new Intent(TrackActivity.this, FavouriteTracksActivity.class));
			}
			
		});
		
		ImageButton searchButton = (ImageButton)findViewById(R.id.search_image_button);
		searchButton.setOnClickListener(new OnClickListener()
		{
			public void onClick(View arg0) {									
				
				InputMethodManager imm = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
				listView.requestFocus();
				imm.toggleSoftInput(2  ,2);					
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

	
	@Override
	public void onDestroy()
	{
		super.onDestroy();	
		this.tracker.dispatch();		
		this.tracker.stop();
		//this.finish();		
	}
}


