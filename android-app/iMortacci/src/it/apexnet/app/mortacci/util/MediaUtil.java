package it.apexnet.app.mortacci.util;

import it.apexnet.app.mortacci.io.MyLibrary;

import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStream;

import android.content.Context;
import android.os.Environment;

public class MediaUtil {

	/***
	 * Create a path where we will place our private file on external storage
	 * @throws Exception 
	 */
	public static void  createExternalStoragePrivateFileTrack(Context context, String fileName, String fileURL) throws Exception {
	 
		File file = new File(context.getExternalFilesDir(Environment.DIRECTORY_MUSIC), fileName);
		
		OutputStream os = new FileOutputStream(file);
		
		os.write(MyLibrary.DownloadFromURL(fileURL));			
	}   
		
}
