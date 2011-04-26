package it.apexnet.app.mortacci.ui;


import org.json.JSONArray;
import org.json.JSONObject;
import org.json.JSONTokener;

import it.apexnet.app.mortacci.R;
import it.apexnet.app.mortacci.library.Album;
import it.apexnet.app.mortacci.library.Albums;
import it.apexnet.app.mortacci.library.Track;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.net.ConnectivityManager;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Toast;

import android.widget.ImageView;

import android.widget.ListView;
import android.widget.TextView;
import android.widget.AdapterView.OnItemClickListener;

public class AlbumActivity extends Activity{
	
	private static String TAG = "AlbumActivity";	
	
	@Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
                
        setContentView(R.layout.activity_albums);
        ((TextView) findViewById(R.id.title_text)).setText(getTitle());
        
        // obtain reference to listview
		ListView listView = (ListView) findViewById(R.id.dialettiListView);
        
		ConnectivityManager conn = (ConnectivityManager)getSystemService(Activity.CONNECTIVITY_SERVICE);
		if (conn.getActiveNetworkInfo() != null && conn.getActiveNetworkInfo().isConnected())
		{
			try
			{
				Bundle bundle = getIntent().getExtras();
				//final Albums albums = (Albums) bundle.get("Albums");
				String jsonText =  bundle.getString("jsonText");							
				
				ArrayAdapter<Album> arrayAdapter = new ArrayAdapter<Album>(this,
						R.layout.list_item_albums, R.id.title_album, this.getAlbums(jsonText))
				{
					
					@Override
					public View getView (int position, View convertView, ViewGroup parent)
					{
						ViewHolder viewHolder = null;
						if (convertView == null)
						{
							LayoutInflater inflater = (LayoutInflater)getSystemService(Context.LAYOUT_INFLATER_SERVICE);
							convertView = inflater.inflate(R.layout.list_item_albums, null);
							viewHolder = new ViewHolder();
							viewHolder.AlbumTitleTextView = (TextView)convertView.findViewById(R.id.title_album);
							viewHolder.AlbumImageView = (ImageView)convertView.findViewById(R.id.image_preview);
							convertView.setTag(viewHolder);
						}
						else
						{
							viewHolder = (ViewHolder)convertView.getTag();
						}							
						Album item = getItem (position);
						viewHolder.AlbumTitleTextView.setText(item.title);
						setImgAlbum (item , viewHolder.AlbumImageView);
						return convertView;
					}
				};
				
				listView.setAdapter(arrayAdapter);
				
				listView.setOnItemClickListener(new OnItemClickListener()
				{
					
					public void onItemClick(AdapterView<?> parent, View view,
			    	        int position, long id)
					{
						
						Album a = ((Album)parent.getAdapter().getItem(position));
						Bundle bundle = new Bundle();			
						bundle.putSerializable("Album", a);
						Intent intent = new Intent(AlbumActivity.this, TrackActivity.class);
						intent.putExtras(bundle);
						startActivity(intent);
					}
				});
			}
			catch (Exception ex)
			{
				Log.e("Album activity", ex.getMessage());
				Toast.makeText(this, "No connection", Toast.LENGTH_SHORT).show();
				
			}
		}
		else
		{
			Toast.makeText(this, "No connection", Toast.LENGTH_SHORT).show();			
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
	
	private Albums getAlbums (String jsonText)
	{		
		Albums albums = null;
		
		try
		{
			JSONTokener tokener = new JSONTokener(jsonText);
			JSONArray albumsArray = null;
		
			try
			{
				albumsArray = new JSONArray(tokener);
			}
		
			catch (Exception ex)
			{
				Log.e(TAG, ex.getMessage());
			}
			
			albums = new Albums();
			
			for (int i = 0; i < albumsArray.length(); i++ )
			{
				JSONObject albumJSONObject = albumsArray.getJSONObject(i);
				
				Album album = new Album();
				
				
				album.ID = albumJSONObject.getInt("id");
				album.slug = albumJSONObject.getString("slug");
				album.description = albumJSONObject.getString("description");
				album.title = albumJSONObject.getString("title");
				
				JSONArray tracksArray = albumJSONObject.getJSONArray("tracks");
				for (int j = 0; j < tracksArray.length(); j++)
				{
					JSONObject trackJSONObject = tracksArray.getJSONObject(j);
					
					Track track = new Track();
					track.album_ID = album.ID;
					track.ID = trackJSONObject.getInt("id");
					track.slug = trackJSONObject.getString("slug");
					track.title = trackJSONObject.getString("title");
					track.description = trackJSONObject.getString("description");
					track.playbackCount = trackJSONObject.getInt("playback_count");
					track.slugAlbum = album.slug;
					
					album.tracks.add(track);
				}
				albums.add(album);
			}
		}
		catch (Exception ex)
		{
			Log.e("getAlbums", ex.getMessage());
		}
		
		return albums;
	}
	
	/*this class contains references to views used in listView*/
    private static class ViewHolder
    {
    	public TextView AlbumTitleTextView;    	
		public ImageView AlbumImageView;
    }
}
