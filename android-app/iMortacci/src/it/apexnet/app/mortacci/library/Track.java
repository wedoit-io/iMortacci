package it.apexnet.app.mortacci.library;

import it.apexnet.app.mortacci.R;

import java.io.Serializable;

import android.provider.BaseColumns;
import android.widget.ImageView;

import it.apexnet.app.mortacci.provider.IMortacciDBContract.TracksColumns;

@SuppressWarnings("serial")
public class Track implements Serializable, TracksColumns, BaseColumns{
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
	
	public void setImgAlbum (ImageView i)
	{
		if (this.slugAlbum.equalsIgnoreCase("abruzzo"))
			i.setImageResource(R.drawable.abruzzo_large);
		else if (this.slugAlbum.equalsIgnoreCase("basilicata"))
			i.setImageResource(R.drawable.basilicata_large);
		else if (this.slugAlbum.equalsIgnoreCase("calabria"))
			i.setImageResource(R.drawable.calabria_large);
		else if (this.slugAlbum.equalsIgnoreCase("campania"))
			i.setImageResource(R.drawable.campania_large);
		else if (this.slugAlbum.equalsIgnoreCase("emiliaromagna"))			
			i.setImageResource(R.drawable.emiliaromagna_large);
		else if (this.slugAlbum.equalsIgnoreCase("friuli"))			
			i.setImageResource(R.drawable.friuli_large);
		else if (this.slugAlbum.equalsIgnoreCase("lazio"))
			i.setImageResource(R.drawable.lazio_large);		
		else if (this.slugAlbum.equalsIgnoreCase("liguria"))			
			i.setImageResource(R.drawable.liguria_large);
		else if (this.slugAlbum.equalsIgnoreCase("lombardia"))			
			i.setImageResource(R.drawable.lombardia_large);									
		else if (this.slugAlbum.equalsIgnoreCase("marche"))			
			i.setImageResource(R.drawable.marche_large);
		else if (this.slugAlbum.equalsIgnoreCase("molise"))			
			i.setImageResource(R.drawable.molise_large);
		else if (this.slugAlbum.equalsIgnoreCase("piemonte"))			
			i.setImageResource(R.drawable.piemonte_large);
		else if (this.slugAlbum.equalsIgnoreCase("puglia"))
			i.setImageResource(R.drawable.puglia_large);
		else if (this.slugAlbum.equalsIgnoreCase("sardegna"))
			i.setImageResource(R.drawable.sardegna_large);
		else if (this.slugAlbum.equalsIgnoreCase("sicilia"))
			i.setImageResource(R.drawable.sicilia_large);		
		else if (this.slugAlbum.equalsIgnoreCase("toscana"))
			i.setImageResource(R.drawable.toscana_large);
		else if (this.slugAlbum.equalsIgnoreCase("trentino"))
			i.setImageResource(R.drawable.trentino_large);
		else if (this.slugAlbum.equalsIgnoreCase("umbria"))
			i.setImageResource(R.drawable.umbria_large);
		else if (this.slugAlbum.equalsIgnoreCase("valledaosta"))
			i.setImageResource(R.drawable.valledaosta_large);
		else if (this.slugAlbum.equalsIgnoreCase("veneto"))
			i.setImageResource(R.drawable.veneto_large);
		else if (this.slugAlbum.equalsIgnoreCase("reggiano"))
			i.setImageResource(R.drawable.emiliaromagna_large);
		else
			i.setImageResource(R.drawable.default_img_large);
	}
}