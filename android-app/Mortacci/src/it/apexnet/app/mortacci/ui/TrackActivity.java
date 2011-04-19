package it.apexnet.app.mortacci.ui;

import java.util.ArrayList;

import it.apexnet.app.mortacci.R;
import it.apexnet.app.mortacci.library.Album;
import it.apexnet.app.mortacci.library.Track;
import it.apexnet.app.mortacci.library.Tracks;
import android.app.Activity;
import android.content.Context;
import android.net.ConnectivityManager;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

public class TrackActivity extends Activity{

	private static String TAG = "TrackActivity";
		
	@Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        
        setContentView(R.layout.activity_tracks);        
        
        ListView listView = (ListView) findViewById(R.id.tracksListView);
        
        ConnectivityManager conn = (ConnectivityManager)getSystemService(Activity.CONNECTIVITY_SERVICE);
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
					setImgAlbum (album , viewHolder.TrackImageView);
					return convertView;
				}				
			};
			
			listView.setAdapter(arrayAdapter);
		}
	}
	
	private void setImgAlbum (Album a, ImageView i)
	{
		if (a.slug.equalsIgnoreCase("calabria"))
			i.setImageResource(R.drawable.calabria);
		else if (a.slug.equalsIgnoreCase("campania"))
			i.setImageResource(R.drawable.campania);
		else if (a.slug.equalsIgnoreCase("puglia"))
			i.setImageResource(R.drawable.puglia);
		else if (a.slug.equalsIgnoreCase("lazio"))
			i.setImageResource(R.drawable.lazio);
		else if (a.slug.equalsIgnoreCase("toscana"))
			i.setImageResource(R.drawable.toscana);
		else if (a.slug.equalsIgnoreCase("veneto"))
			i.setImageResource(R.drawable.veneto);
		else if (a.slug.equalsIgnoreCase("emiliaromagna"))
			i.setImageResource(R.drawable.emiliaromagna);
		else if (a.slug.equalsIgnoreCase("sardegna"))
			i.setImageResource(R.drawable.sardegna);
		else if (a.slug.equalsIgnoreCase("sicilia"))
			i.setImageResource(R.drawable.sicilia);		
		else
			i.setImageResource(R.drawable.default_img);
		
	}
	
	private static class ViewHolder
	{
		public TextView TrackTitleTextView;    	
		public TextView PlaybackCountTextView;
		public ImageView TrackImageView;
	}
}


