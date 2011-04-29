package it.apexnet.app.mortacci.io;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;

public class MyLibrary {

	 public static String convertStreamToString(InputStream is) {
	        /*
	         * To convert the InputStream to String we use the BufferedReader.readLine()
	         * method. We iterate until the BufferedReader return null which means
	         * there's no more data to read. Each line will appended to a StringBuilder
	         * and returned as String.
	         */
	        BufferedReader reader = null;		
	        InputStreamReader inputStreamReader = new InputStreamReader(is); 
			reader = new BufferedReader(inputStreamReader);
			//String encoding = inputStreamReader.getEncoding();
			
	        StringBuilder sb = new StringBuilder();
	 
	        String line;
	        try {
	            while ((line = reader.readLine()) != null) {
	                sb.append(line + "\n");
	            }
	        } catch (IOException e) {
	            e.printStackTrace();
	        } finally {
	            try {
	            	inputStreamReader.close();
	            } catch (IOException e) {
	                e.printStackTrace();
	            }
	        }        
	        try {

	        	return sb.toString();
	        	
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			return "";
	        //return sb.toString();	   
	}
	 
 	public static void CopyStream(InputStream is, OutputStream os)
    {
        final int buffer_size=1024;
        try
        {
            byte[] bytes=new byte[buffer_size];
            for(;;)
            {
              int count=is.read(bytes, 0, buffer_size);
              if(count==-1)
                  break;
              os.write(bytes, 0, count);
            }
        }
        catch(Exception ex){}
    }
}
