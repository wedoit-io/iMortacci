package it.apexnet.app.mortacci.util;

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
}
