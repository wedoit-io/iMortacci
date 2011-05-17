package it.apexnet.app.mortacci.ui;

import it.apexnet.app.mortacci.R;
import it.apexnet.app.mortacci.io.HttpCall;
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
	protected int _splashTime = 1000; // 10 sec
	protected int _minSplashTime = 2000;
	protected int waited;
	Thread getDataThread, splashThread;
	private boolean noConnection;
	private String jsonText;
	private Handler myGetDataThreadHandler, mySplashThreadHandler;
	
	@Override
	public void onCreate(Bundle savedInstanceState) {
	    super.onCreate(savedInstanceState);
	    setContentView(R.layout.activity_splash);
	    
	    this.getDataThread = null;
	    this.splashThread = null;
	    this.noConnection = false;
	    this.jsonText = "";
	    this.waited = 0;
	    
	    
	    myGetDataThreadHandler = new Handler()
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
	    
	    mySplashThreadHandler = new Handler()
	    {
	    	public void handleMessage (Message msg)
	    	{	
	    		if (noConnection)
	    		{
	    			
	    			//Intent i = (new Intent (SplashActivity.this, TrackActivity.class));
	    			//i.setFlags(Intent.FLAG_ACTIVITY_NO_HISTORY);
	    			//i.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
	    			startActivity (new Intent (SplashActivity.this, NoConnectionActivity.class));
	    			Log.i("mySplashThreadHandler", "noconnection");
	    			finish();
	    		}
	    		Log.i("mySplashThreadHandler", "interrupt");	    			    	
	    	}
	    };
	    
	    
	    
	    splashThread = new Thread(this, "ThreadSplashAcitivity") {
	        @Override
	        public void run() {
	            try {
	                waited = 0; noConnection = false;
	                while(_active && (waited < _splashTime)) {
	                    sleep(2000);
	                    if(_active) {
	                        waited += 200;
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
	    
	    
	    getDataThread = new Thread(){
	    	@Override
	    	 public void run() {
	    		
	    		boolean hasJson = false;
	    		 try
	    		 {
	    			 noConnection = true;
	    			 
	    			 Log.i(TAG, "getDataThread");
	    			 String urlWS = getResources().getString(R.string.URIws) + getResources().getString(R.string.albumsWithTracksURIws);
	    			 
	    			 
	    			 while (!hasJson)
	    			 {
		    			 jsonText = "";
		    			 noConnection = false;
		    			 ConnectivityManager conn = (ConnectivityManager)getSystemService(Activity.CONNECTIVITY_SERVICE);
		    			 if (conn.getActiveNetworkInfo() != null && conn.getActiveNetworkInfo().isConnected())
		    			 {
		    				 Log.i(TAG, "http call");
							jsonText = HttpCall.getJSONtext(urlWS);
		    			 }
    		 	    			 
		    			 if (! jsonText.equals("") && !noConnection)
		    			 {
		    				 Log.i("Noconnection", "false");
		    				 Log.i("jsonText", jsonText);
		    				 noConnection = false;
		    				 hasJson = true;
		    				 notifyAlbums(jsonText);	
		    				 splashThread.interrupt();
			    			 interrupt();
		    			 }
		    			 sleep(1000);	  
	    			 }
	    			 
	    		 }	    		 
	    		 catch (InterruptedException ex)
	    		 {
	    			 //getDataThread has received an interrupt, so hasJson variable stop while cycle
	    			 hasJson = true;
	    			 HttpCall.closeStream();
	    		 }
	    		 catch (Exception  e)
	    		 {	    		
	    			 HttpCall.closeStream();
	    		 }
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
	    
	    getDataThread.start();
	    splashThread.start();	    
	}

	
	@Override
	public void onStop()
	{
		super.onStop();		
		try
		{
			myGetDataThreadHandler.removeCallbacks(getDataThread);
			mySplashThreadHandler.removeCallbacks(splashThread);
			mySplashThreadHandler = null;
			myGetDataThreadHandler = null;
			HttpCall.closeStream();
			this.getDataThread.interrupt();
			this.splashThread.interrupt();
			this.getDataThread = null;
		    this.splashThread = null;
			this.noConnection = false;
			this.jsonText = "";
		    this.waited = 0;
		}
		catch(Exception e)
		{}
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
