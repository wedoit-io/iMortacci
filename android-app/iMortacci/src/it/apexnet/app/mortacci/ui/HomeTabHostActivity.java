package it.apexnet.app.mortacci.ui;

import it.apexnet.app.mortacci.R;
import android.app.TabActivity;
import android.content.Intent;
import android.os.Bundle;
import android.widget.TabHost;

public class HomeTabHostActivity extends TabActivity {

	@Override
    public void onCreate(Bundle savedInstanceState) {
    	super.onCreate(savedInstanceState);
    	
    	setContentView(R.layout.activity_tab_host);
    	
    	Bundle bundle = getIntent().getExtras();
    	
    	//Resources res = getResources(); // Resource object to get Drawables
        TabHost tabHost = getTabHost();  // The activity TabHost
        TabHost.TabSpec spec;  // Resusable TabSpec for each tab
        Intent intent;  // Reusable Intent for each tab
        
        intent = new Intent().setClass(this, AlbumActivity.class);
        intent.putExtras(bundle);
        spec = tabHost.newTabSpec("albums").setIndicator("Albums").setContent(intent);
        tabHost.addTab(spec);
        
        
        intent = new Intent().setClass(this, FavouriteTracksActivity.class);
        spec = tabHost.newTabSpec("favourite").setIndicator("Preferiti").setContent(intent);
        tabHost.addTab(spec);   
	}
}
