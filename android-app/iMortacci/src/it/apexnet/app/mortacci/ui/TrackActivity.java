package it.apexnet.app.mortacci.ui;

import java.util.ArrayList;

import com.google.ads.AdRequest;
import com.google.ads.AdSize;

import it.apexnet.app.mortacci.R;
import it.apexnet.app.mortacci.library.Album;
import it.apexnet.app.mortacci.library.Track;
import it.apexnet.app.mortacci.util.UIUtils;
import it.apexnet.app.mortacci.widget.AdViewLoader;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.net.ConnectivityManager;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.AdapterView.OnItemClickListener;

public class TrackActivity extends Activity{

	//private static String TAG = "TrackActivity";
		
	@Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        
        setContentView(R.layout.activity_tracks);        
        
        ListView listView = (ListView) findViewById(R.id.tracksListView);
        
        ConnectivityManager conn = (ConnectivityManager)getSystemService(Activity.CONNECTIVITY_SERVICE);
        try
        {
		if (conn.getActiveNetworkInfo() != null && conn.getActiveNetworkInfo().isConnected())
		{
			Bundle bundle = getIntent().getExtras();
					
			final Album album = (Album)bundle.get("Album");
			((TextView) findViewById(R.id.title_text)).setText(album.title);
			
			ArrayList<Track> trackList = album.tracks;
			
			ArrayAdapter<Track> arrayAdapter = new ArrayAdapter<Track>(this,
					R.layout.list_item_albums, R.id.title_album, trackList)
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
					Intent intent = new Intent(TrackActivity.this, PlayTrackActivity.class);
					intent.putExtras(bundle);
					startActivity(intent);			
				}
			});		
		}
		else
		{
			Toast.makeText(this, "No connection", Toast.LENGTH_SHORT).show();			
		}
        }catch (Exception e)
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
	    LinearLayout layout = (LinearLayout)findViewById(R.id.root_linear_layout);
	    // Add the adView to it
	    AdRequest request = new AdRequest();
	    request.setTesting(true);
    	layout.addView(adView);		    	
	    adView.loadAd(request);
	}
		
	private void onHomeClick ()
    {
    	UIUtils.goHome(this);
    }
	
	private static class ViewHolder
	{
		public TextView TrackTitleTextView;    	
		public TextView PlaybackCountTextView;
		public ImageView TrackImageView;
	}
	
	@Override
	public void onDestroy()
	{
		super.onDestroy();	
		//this.finish();		
	}
}


