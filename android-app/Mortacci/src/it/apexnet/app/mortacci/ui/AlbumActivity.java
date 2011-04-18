package it.apexnet.app.mortacci.ui;

import org.json.JSONArray;
import org.json.JSONObject;
import org.json.JSONTokener;

import it.apexnet.app.mortacci.R;
import it.apexnet.app.mortacci.library.Album;
import it.apexnet.app.mortacci.library.Track;
import it.apexnet.mortacci.io.HttpCall;
import android.app.Activity;
import android.content.Context;
import android.net.ConnectivityManager;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import android.widget.TextView;

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
				ArrayAdapter<Album> arrayAdapter = new ArrayAdapter<Album>(this,
						R.layout.list_item_albums, R.id.title_album, this.getAlbums())
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
							convertView.setTag(viewHolder);
						}
						else
						{
							viewHolder = (ViewHolder)convertView.getTag();
						}							
						Album item = getItem (position);
						viewHolder.AlbumTitleTextView.setText(item.title);
						return convertView;
					}
				};
				
				listView.setAdapter(arrayAdapter);
			}
			catch (Exception ex)
			{
				
			}
		}
	}
	
	private Album [] getAlbums ()
	{
		String urlWS = getResources().getString(R.string.URIws) + getResources().getString(R.string.albumsWithTracksURIws);
		
		String jsonText = HttpCall.getJSONtext(urlWS);
		
		Album albums [] = null;
		
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
			
			albums = new Album[albumsArray.length()];
			
			for (int i = 0; i < albumsArray.length(); i++ )
			{
				JSONObject albumJSONObject = albumsArray.getJSONObject(i);
				
				albums[i] = new Album();
				albums[i].ID = albumJSONObject.getInt("id");
				albums[i].slug = albumJSONObject.getString("slug");
				albums[i].description = albumJSONObject.getString("description");
				albums[i].title = albumJSONObject.getString("title");
				
				JSONArray tracksArray = albumJSONObject.getJSONArray("tracks");
				for (int j = 0; j < tracksArray.length(); j++)
				{
					JSONObject trackJSONObject = tracksArray.getJSONObject(i);
					
					Track track = new Track();
					track.album_ID = albums[i].ID;
					track.ID = trackJSONObject.getInt("id");
					track.slug = trackJSONObject.getString("slug");
					track.title = trackJSONObject.getString("title");
					track.description = trackJSONObject.getString("description");
					
					albums[i].track.add(track);
				}				
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
    	
    }
}
