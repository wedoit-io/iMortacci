package it.apexnet.app.mortacci.library;

import it.apexnet.app.mortacci.R;
import it.apexnet.app.mortacci.provider.IMortacciDBContract.AlbumsColumns;

import java.io.Serializable;
import java.util.ArrayList;

import android.provider.BaseColumns;
import android.widget.ImageView;

@SuppressWarnings("serial")
public class Album implements Serializable, AlbumsColumns, BaseColumns{
	
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
	
	public void setImgAlbum (ImageView i)
	{
		if (this.slug.equalsIgnoreCase("abruzzo"))
			i.setImageResource(R.drawable.abruzzo);
		else if (this.slug.equalsIgnoreCase("basilicata"))
			i.setImageResource(R.drawable.basilicata);
		else if (this.slug.equalsIgnoreCase("calabria"))
			i.setImageResource(R.drawable.calabria);
		else if (this.slug.equalsIgnoreCase("campania"))
			i.setImageResource(R.drawable.campania);
		else if (this.slug.equalsIgnoreCase("emiliaromagna"))			
			i.setImageResource(R.drawable.emiliaromagna);
		else if (this.slug.equalsIgnoreCase("friuli"))			
			i.setImageResource(R.drawable.friuli);
		else if (this.slug.equalsIgnoreCase("lazio"))
			i.setImageResource(R.drawable.lazio);		
		else if (this.slug.equalsIgnoreCase("liguria"))			
			i.setImageResource(R.drawable.liguria);
		else if (this.slug.equalsIgnoreCase("lombardia"))			
			i.setImageResource(R.drawable.lombardia);									
		else if (this.slug.equalsIgnoreCase("marche"))			
			i.setImageResource(R.drawable.marche);
		else if (this.slug.equalsIgnoreCase("molise"))			
			i.setImageResource(R.drawable.molise);
		else if (this.slug.equalsIgnoreCase("piemonte"))			
			i.setImageResource(R.drawable.piemonte);
		else if (this.slug.equalsIgnoreCase("puglia"))
			i.setImageResource(R.drawable.puglia);
		else if (this.slug.equalsIgnoreCase("sardegna"))
			i.setImageResource(R.drawable.sardegna);
		else if (this.slug.equalsIgnoreCase("sicilia"))
			i.setImageResource(R.drawable.sicilia);		
		else if (this.slug.equalsIgnoreCase("toscana"))
			i.setImageResource(R.drawable.toscana);
		else if (this.slug.equalsIgnoreCase("trentino"))
			i.setImageResource(R.drawable.trentino);
		else if (this.slug.equalsIgnoreCase("umbria"))
			i.setImageResource(R.drawable.umbria);
		else if (this.slug.equalsIgnoreCase("valledaosta"))
			i.setImageResource(R.drawable.valledaosta);
		else if (this.slug.equalsIgnoreCase("veneto"))
			i.setImageResource(R.drawable.veneto);
		else if (this.slug.equalsIgnoreCase("reggiano"))
			i.setImageResource(R.drawable.emiliaromagna);
		else
			i.setImageResource(R.drawable.default_img);
	}
}
