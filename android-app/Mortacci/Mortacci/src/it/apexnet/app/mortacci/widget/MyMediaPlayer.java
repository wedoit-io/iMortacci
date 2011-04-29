package it.apexnet.app.mortacci.widget;

import android.media.MediaPlayer;

public class MyMediaPlayer extends MediaPlayer{

	private static MyMediaPlayer istance = null;
	
	private MyMediaPlayer() {}
	
	
	public static synchronized MyMediaPlayer getMyMediaPlayer(boolean newInstance) {
        if (newInstance) 
        	istance = new MyMediaPlayer();
        return istance;
    }
}
