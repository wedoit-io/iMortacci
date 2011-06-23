package it.apexnet.app.mortacci.ui;

import it.apexnet.app.mortacci.R;
import it.apexnet.app.mortacci.io.HttpCall;
import android.app.Activity;
import android.content.Intent;
import android.net.ConnectivityManager;
import android.os.AsyncTask;
import android.os.Bundle;
import android.util.Log;



public class SplashActivity extends Activity {

	private static String TAG = "SplashActivity";
	private static int timeToRetreive = 5;
	
	protected boolean _active = true;
	protected int _splashTime = 1000; // 10 sec
	protected int _minSplashTime = 2000;
	protected int waited;	
	private boolean hasConnection;		
	SplashSync splashSync;
	GetDataSync getDataSync;
	
	public boolean GetHasConnection()
	{
		synchronized (this) {
			return this.hasConnection;
		}
	}
	
	public void SetHasConnection(boolean value)
	{
		synchronized (this) {
			this.hasConnection = value;
		}
	}
	
	@Override
	public void onCreate(Bundle savedInstanceState) {
	    super.onCreate(savedInstanceState);
	    setContentView(R.layout.activity_splash);
	    	    
	    this.hasConnection = false;	    
	    this.waited = 0;
	    	    
	    this.splashSync = new SplashSync();
	    this.getDataSync = new GetDataSync();
	    
	    this.splashSync.execute();
	    this.getDataSync.execute();
	}

	
	@Override
	public void onStop()
	{
		super.onStop();		
		try
		{			
			HttpCall.closeStream();			
			SetHasConnection(false);	
		    this.waited = 0;
		    
		    if (this.splashSync != null && !this.splashSync.isCancelled())
		    	this.splashSync.cancel(true);
		    
		    if (this.getDataSync != null && !this.getDataSync.isCancelled())
		    	this.getDataSync.cancel(true);
		}
		catch(Exception e)
		{}
	}
	
	@Override
	public void onDestroy()
	{
		super.onDestroy();				
	}
	
	
	private class SplashSync extends AsyncTask<Void, Void, Void>
	{

		@Override
		protected Void doInBackground(Void... params) {
			// TODO Auto-generated method stub
			try {
                waited = 0; 
                while(_active && (waited < _splashTime)) {
                    Thread.sleep(2000);
                    if(_active) {
                        waited += 200;
                    }
                    if (GetHasConnection())
                    	_active = false;
                }	
			}
			catch (Exception ex)
			{}
			
			return null;
		}
		
		@Override
		protected void onPostExecute(Void x)
		{			
			if (!GetHasConnection())
			{				
				Intent i = new Intent (SplashActivity.this, FavouriteTracksActivity.class);				
				startActivity (i);
    			Log.i("mySplashThreadHandler", "noconnection");
    			finish();
			}
		}
	}
	
	private class GetDataSync extends AsyncTask<Void, Void, String>
	{

		@Override
		protected String doInBackground(Void... params) {
			// TODO Auto-generated method stub
			
			boolean hasJson = false;
			String jsonText = "";
   		 try
   		 {   			
   			 Log.i(TAG, "getDataThread");
   			 String urlWS = getResources().getString(R.string.URIws) + getResources().getString(R.string.albumsWithTracksURIws);
   			  
   			 int count = 0;
   			 while (!hasJson && count < timeToRetreive)
   			 {
    			 jsonText = "";	    			 
    			 ConnectivityManager conn = (ConnectivityManager)getSystemService(Activity.CONNECTIVITY_SERVICE);
    			 if (conn.getActiveNetworkInfo() != null && conn.getActiveNetworkInfo().isConnected())
    			 {
    				 Log.i(TAG, "http call");
    				 jsonText = HttpCall.getJSONtext(urlWS);
    			 }
	 	    			 
    			 if (! jsonText.equals("") && !GetHasConnection())
    			 {
    				 Log.i("Noconnection", "false");
    				 Log.i("jsonText", jsonText);
    				 SetHasConnection(true);
    				 hasJson = true;    				 
    			 }
    			 count ++;
    			 Thread.sleep(1000);	  
   			 }   			 
   		 }	    		    		
   		 catch (Exception  e)
   		 {	  
   			 hasJson = true;		
   			 HttpCall.closeStream();
   		 }
   		 finally
   		 {}
			
			return jsonText;
		}
		
		@Override
		protected void onPostExecute( String jsonText)
		{
			if (GetHasConnection())
			{
				 Bundle bundle = new Bundle();
				 bundle.putString("jsonText", jsonText);
				 Intent intent = new Intent(SplashActivity.this, AlbumActivity.class);		    		
				 intent.putExtras(bundle);
				 startActivity(intent);
				 Log.i("myGetDataThreadHandler", "siConnection");
				 finish();
			}
		}
		
	}
}


