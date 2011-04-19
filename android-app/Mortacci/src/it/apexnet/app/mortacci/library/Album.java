package it.apexnet.app.mortacci.library;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

@SuppressWarnings("serial")
public class Album implements Serializable{
	
	public int ID;
	public String slug;
	public String title;
	public String description;
	public String alternateDesc;
	public ArrayList<Track> tracks;
	
	public Album ()
	{
		this.tracks = new ArrayList<Track>();
	}
}
