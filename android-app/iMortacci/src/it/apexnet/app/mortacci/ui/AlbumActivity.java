package it.apexnet.app.mortacci.ui;


import org.json.JSONArray;
import org.json.JSONObject;
import org.json.JSONTokener;

import com.google.ads.Ad;
import com.google.ads.AdRequest;
import com.google.ads.AdSize;
import com.google.ads.AdRequest.ErrorCode;

import it.apexnet.app.mortacci.R;
import it.apexnet.app.mortacci.library.Album;
import it.apexnet.app.mortacci.library.Albums;
import it.apexnet.app.mortacci.library.Track;
import it.apexnet.app.mortacci.provider.IMortacciDBProvider;
import it.apexnet.app.mortacci.widget.AdViewLoader;
import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.media.AudioManager;
import android.net.ConnectivityManager;
import android.os.AsyncTask;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.view.MenuItem.OnMenuItemClickListener;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ImageButton;
import android.widget.LinearLayout;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.AdapterView.OnItemClickListener;

public class AlbumActivity extends Activity {
	
	private static String TAG = "AlbumActivity";
	private final IMortacciDBProvider db = new IMortacciDBProvider(this);
	private ListView listView;
		
	@Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
                
        setContentView(R.layout.activity_albums);
        ((TextView) findViewById(R.id.title_text)).setText(getTitle());
        
        setVolumeControlStream(AudioManager.STREAM_MUSIC);
        
        // obtain reference to listview
		this.listView = (ListView) findViewById(R.id.dialettiListView);        		
		
		//this.db = new IMortacciDBProvider(this);				
		//Cursor cursor = this.db.query(false, Views.FAVOURITE_TRACKS_VIEW, FavouriteTracksViewColumns.COLUMNS , null, null, null, null, null, null);
		
		ConnectivityManager conn = (ConnectivityManager)getSystemService(Activity.CONNECTIVITY_SERVICE);
		if (conn.getActiveNetworkInfo() != null && conn.getActiveNetworkInfo().isConnected())
		{
			try
			{
				Bundle bundle = getIntent().getExtras();
				//final Albums albums = (Albums) bundle.get("Albums");
				String jsonText =  bundle.getString("jsonText");							
				
				new CreateAlbumsListSync().execute(jsonText);				
			}
			catch (Exception ex)
			{
				Log.e("Album activity", ex.getMessage());
				startActivity (new Intent (this, NoConnectionActivity.class));
			}
		}
		else
		{
			startActivity (new Intent (this, NoConnectionActivity.class));			
		}
		
		ImageButton favouriteButton = (ImageButton)findViewById(R.id.favourite_image_button);
		favouriteButton.setOnClickListener(new OnClickListener()
		{
			public void onClick(View arg0) {
				startActivity(new Intent(AlbumActivity.this, FavouriteTracksActivity.class));
			}
			
		});
		
		// Create the adView
		AdViewLoader adView = new AdViewLoader(this, AdSize.BANNER);			    
	    // Lookup your LinearLayout assuming it�s been given
	    // the attribute android:id="@+id/mainLayout"
	    LinearLayout layout = (LinearLayout)findViewById(R.id.root_linear_layout);
	    // Add the adView to it
	    AdRequest request = new AdRequest();	       
    	layout.addView(adView);		    	
	    adView.loadAd(request);
	}
		
	
	private class CreateAlbumsListSync extends AsyncTask<String, Void, ArrayAdapter<Album>>
	{
		private final ProgressDialog dialog = new ProgressDialog(AlbumActivity.this);
		
		@Override
		protected void onPreExecute() {			
            this.dialog.show();		            
		}
		
		@Override
		protected ArrayAdapter<Album> doInBackground(String... jsonTexts) {
			// TODO Auto-generated method stub
			Albums albums = null;
			
			for (String jsonText : jsonTexts)
				albums = getAlbums(jsonText);
			
			ArrayAdapter<Album> arrayAdapter = new ArrayAdapter<Album>(AlbumActivity.this,
					R.layout.list_item_albums, R.id.title_album, albums)
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
					item.setImgAlbum (viewHolder.AlbumImageView);
					return convertView;
				}
			};
			
			return arrayAdapter;
		}
		
		@Override
		protected void onPostExecute(ArrayAdapter<Album> arrayAdapter)
		{									
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
			
			if(this.dialog.isShowing())
                this.dialog.dismiss();
		}		
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
				for (int j = tracksArray.length() -1 ; j >= 0 ; j--)
				{
					JSONObject trackJSONObject = tracksArray.getJSONObject(j);
					
					Track track = new Track();
					track.album_ID = album.ID;
					track.ID = trackJSONObject.getInt("id");
					track.slug = trackJSONObject.getString("slug");
					track.title = trackJSONObject.getString("title");
					track.description = trackJSONObject.getString("description");
					track.playbackCount = trackJSONObject.getInt("playback_count");
					track.likeCount = trackJSONObject.getInt("like_count");
					track.downloadURL = trackJSONObject.getString("download_url");
					track.waveformURL = trackJSONObject.getString("waveform_url");
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
	
	@Override
	 public boolean onCreateOptionsMenu(Menu menu) {
		 super.onCreateOptionsMenu(menu);
		 
		 int order = Menu.FIRST;
		 
		 Intent creditsIntent = new Intent(this, CreditsActivity.class);
		 creditsIntent.setFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP);
		 
		 menu.add(0, 0, order++, "Credits").setIcon(R.drawable.credits).setIntent(creditsIntent);;
					 
		 
		 menu.add(0, 0, order++, "Exit").setIcon(R.drawable.exit).setOnMenuItemClickListener(new OnMenuItemClickListener()
		 {

			public boolean onMenuItemClick(MenuItem arg0) {
				android.os.Process.killProcess(android.os.Process.myPid());
				return false;
			}
			 
		 });
			 
		 
		// Visualizziamo il Menu
		return true;
	 }
	

	
	/*this class contains references to views used in listView*/
    private static class ViewHolder
    {
    	public TextView AlbumTitleTextView;    	
		public ImageView AlbumImageView;
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
	public void onDestroy()
	{
		super.onDestroy();	
		this.db.close();
		//this.dbHelper.close();
		//android.os.Process.killProcess(android.os.Process.myPid());
	}
}
