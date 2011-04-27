package it.apexnet.app.mortacci.library;

import it.apexnet.app.mortacci.R;

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
	
	public void setImgAlbum (ImageView i)
	{
		if (this.slugAlbum.equalsIgnoreCase("abruzzo"))
			i.setImageResource(R.drawable.abruzzo);
		else if (this.slugAlbum.equalsIgnoreCase("basilicata"))
			i.setImageResource(R.drawable.basilicata);
		else if (this.slugAlbum.equalsIgnoreCase("calabria"))
			i.setImageResource(R.drawable.calabria);
		else if (this.slugAlbum.equalsIgnoreCase("campania"))
			i.setImageResource(R.drawable.campania);
		else if (this.slugAlbum.equalsIgnoreCase("emiliaromagna"))			
			i.setImageResource(R.drawable.emiliaromagna);
		else if (this.slugAlbum.equalsIgnoreCase("friuli"))			
			i.setImageResource(R.drawable.friuli);
		else if (this.slugAlbum.equalsIgnoreCase("lazio"))
			i.setImageResource(R.drawable.lazio);		
		else if (this.slugAlbum.equalsIgnoreCase("liguria"))			
			i.setImageResource(R.drawable.liguria);
		else if (this.slugAlbum.equalsIgnoreCase("lombardia"))			
			i.setImageResource(R.drawable.lombardia);									
		else if (this.slugAlbum.equalsIgnoreCase("marche"))			
			i.setImageResource(R.drawable.marche);
		else if (this.slugAlbum.equalsIgnoreCase("molise"))			
			i.setImageResource(R.drawable.molise);
		else if (this.slugAlbum.equalsIgnoreCase("piemonte"))			
			i.setImageResource(R.drawable.piemonte);
		else if (this.slugAlbum.equalsIgnoreCase("puglia"))
			i.setImageResource(R.drawable.puglia);
		else if (this.slugAlbum.equalsIgnoreCase("sardegna"))
			i.setImageResource(R.drawable.sardegna);
		else if (this.slugAlbum.equalsIgnoreCase("sicilia"))
			i.setImageResource(R.drawable.sicilia);		
		else if (this.slugAlbum.equalsIgnoreCase("toscana"))
			i.setImageResource(R.drawable.toscana);
		else if (this.slugAlbum.equalsIgnoreCase("trentino"))
			i.setImageResource(R.drawable.trentino);
		else if (this.slugAlbum.equalsIgnoreCase("umbria"))
			i.setImageResource(R.drawable.umbria);
		else if (this.slugAlbum.equalsIgnoreCase("valledaosta"))
			i.setImageResource(R.drawable.valledaosta);
		else if (this.slugAlbum.equalsIgnoreCase("veneto"))
			i.setImageResource(R.drawable.veneto);
		else if (this.slugAlbum.equalsIgnoreCase("reggiano"))
			i.setImageResource(R.drawable.emiliaromagna);
		else
			i.setImageResource(R.drawable.default_img);
	}
}