package it.apexnet.app.mortacci.ui;


import it.apexnet.app.mortacci.R;
import it.apexnet.mortacci.io.HttpCall;
import android.app.Activity;
import android.content.Intent;
import android.net.ConnectivityManager;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.util.Log;


public class SplashActivity extends Activity implements Runnable {

	private static String TAG = "SplashActivity";
	protected boolean _active = true;
	protected int _splashTime = 8000;
	protected int _minSplashTime = 2000;
	protected int waited;
	Thread getDataThread, splashThread;
	private boolean noConnection;
	private String jsonText;
	
	@Override
	public void onCreate(Bundle savedInstanceState) {
	    super.onCreate(savedInstanceState);
	    setContentView(R.layout.splash_activity);
	    
	    this.getDataThread = null;
	    this.splashThread = null;
	    this.noConnection = false;
	    this.jsonText = "";
	    
	    final Handler mySplashThreadHandler = new Handler()
	    {
	    	public void handleMessage (Message msg)
	    	{	
	    		if (noConnection)
	    		{
	    			finish();
	    			Intent i = (new Intent (SplashActivity.this, TrackActivity.class));
	    			i.setFlags(Intent.FLAG_ACTIVITY_NO_HISTORY);
	    			i.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
	    			startActivity (new Intent (SplashActivity.this, TrackActivity.class));
	    			Log.i("mySplashThreadHandler", "noconnection");
	    		}
	    		Log.i("mySplashThreadHandler", "interrupt");	    			    	
	    	}
	    };
	    
	    
	    final Handler myGetDataThreadHandler = new Handler()
	    {
	    	public void handleMessage (Message msg)
	    	{		    		
	    		if (! noConnection)
	    		{
		    		Bundle bundle = msg.getData();
		    		Intent intent = new Intent(SplashActivity.this, AlbumActivity.class);	    		
		    		intent.putExtras(bundle);
		    		startActivity(intent);
		    		Log.i("myGetDataThreadHandler", "siConnection");
		    		finish();	 
	    		}
	    			   		
	    		Log.i("myGetDataThreadHandler", "interrupt");	    		    	
	    	}
	    };
	    
	    
	    getDataThread = new Thread(this, "getDataThread")
	    {
	    	 @Override
	    	 public void run() {
	    		 try
	    		 {
	    			 String urlWS = getResources().getString(R.string.URIws) + getResources().getString(R.string.albumsWithTracksURIws);
	    			 noConnection = false;
	    			 jsonText = "";
	    			 ConnectivityManager conn = (ConnectivityManager)getSystemService(Activity.CONNECTIVITY_SERVICE);
	    			 if (conn.getActiveNetworkInfo() != null && conn.getActiveNetworkInfo().isConnected())
	    			 {
						jsonText = HttpCall.getJSONtext(urlWS);
	    			 }
	    		 	    			 
	    			 if (! jsonText.equals("") && !noConnection)
	    			 {
	    				 Log.i("Noconnection", "false");
	    				 Log.i("jsonText", jsonText);
	    				 noConnection = false;
	    				 notifyAlbums(jsonText);	    				 
	    				 splashThread.interrupt();
	    				 interrupt();
	    			 }	    			 
	    		 }
	    		 catch (Exception ex)
	    		 {}
	    		 finally
	    		 {}
	    	 }
	    	 
	    	 private void notifyAlbums (String jsonText)
	    	 {	    		
	    		 Message msg = myGetDataThreadHandler.obtainMessage();
	    		 Bundle b = new Bundle();
	    		 b.putString("jsonText", jsonText);
	    		 msg.setData(b);
	    		 myGetDataThreadHandler.sendMessage(msg);
	    	 }
	    	 	    	 
	    };
	    
	    splashThread = new Thread(this, "ThreadSplashAcitivity") {
	        @Override
	        public void run() {
	            try {
	                waited = 0; noConnection = false;
	                while(_active && (waited < _splashTime)) {
	                    sleep(100);
	                    if(_active) {
	                        waited += 100;
	                    }
	                }	 
	                noConnection = true;	                
	                Message msg = mySplashThreadHandler.obtainMessage();
	                mySplashThreadHandler.sendMessage(msg);
	                getDataThread.interrupt();
		    		interrupt();
	            } catch(InterruptedException e) {
	                // do nothing
	            } finally {	            	
	            }
	        }
	    };
	    
	    getDataThread.start();
	    splashThread.start();
	    
	}

	@Override
	public void onDestroy()
	{
		super.onDestroy();		
	}
	
	public void run() {
		// TODO Auto-generated method stub
		
	}
}
