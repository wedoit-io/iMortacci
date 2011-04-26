package it.apexnet.mortacci.io;

import java.io.IOException;
import java.io.InputStream;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.HttpStatus;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.params.BasicHttpParams;
import org.apache.http.params.HttpConnectionParams;
import org.apache.http.params.HttpParams;

import android.util.Log;

public class HttpCall {

	private static String TAG = "HttpCall";
	static int timeout = 5000;		
	
	public static String getJSONtext (String urlWS)
	{			

		HttpParams httpParameters = new BasicHttpParams();
		HttpConnectionParams.setConnectionTimeout(httpParameters, timeout);		
		HttpClient client = new DefaultHttpClient();
		String jsonText = "";
		HttpGet get = new HttpGet(urlWS);
		HttpResponse response = null;
		InputStream instream= null;
						
		try 
		{
			response = client.execute(get);
		} 
		catch (ClientProtocolException e1)
		{
			// TODO Auto-generated catch block
			Log.e(TAG, e1.getMessage());
			e1.printStackTrace();			
		} 
		catch (IOException e1) 
		{
			// TODO Auto-generated catch block\
			Log.e(TAG, e1.getMessage());
			e1.printStackTrace();			
		}					
		int status = response.getStatusLine().getStatusCode();
		
		if (status == HttpStatus.SC_OK) 
		{
			HttpEntity entity = response.getEntity();
			
			try
			{
				instream = entity.getContent();			
			}
			catch (IllegalStateException e)
			{
				// TODO Auto-generated catch block
				e.printStackTrace();			
			} 
			catch (IOException e)
			{
				// TODO Auto-generated catch block
				e.printStackTrace();			
			}
			
			jsonText = MyLibrary.convertStreamToString(instream);
		}
		try {
			instream.close();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return jsonText;
	}
}
