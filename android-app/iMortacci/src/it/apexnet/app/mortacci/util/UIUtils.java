package it.apexnet.app.mortacci.util;

import it.apexnet.app.mortacci.R;
import it.apexnet.app.mortacci.ui.AlbumActivity;
import android.content.Context;
import android.content.Intent;

public class UIUtils {
	/**
     * Invoke "home" action, returning to {@link AlbumActivity}.
     */
    public static void goHome(Context context) {
        final Intent intent = new Intent(context, AlbumActivity.class);
        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);        
        context.startActivity(intent);
    }
    
    public static void share(String title, String subject, String text, Context context)
    {
		final Intent intent = new Intent(Intent.ACTION_SEND);			
		
		intent.setType("text/plain");
		intent.putExtra(Intent.EXTRA_TITLE, title);
		intent.putExtra(Intent.EXTRA_SUBJECT, subject);
		intent.putExtra(Intent.EXTRA_TEXT, text);		
		 
		context.startActivity(Intent.createChooser(intent,  context.getResources().getString(R.string.share)));
    }
}
