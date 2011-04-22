package it.apexnet.app.mortacci.library;

import java.io.Serializable;

import android.widget.ImageView;


@SuppressWarnings("serial")
public class Track implements Serializable{
	public static final String CLIENT_ID = "7Eo3B0odlpK5FvOVUKDnQ";
	
	public int album_ID;
	public int ID;
	public String slug;
	public String title;
	public String description;
	public String alternateDesc;
	public int playbackCount;
	public int likeCount;
	
	public String downloadURL;
	public String streamURL;
	public String waveformURL;
	public String slugAlbum;	
}