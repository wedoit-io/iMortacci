package it.apexnet.app.mortacci.ui;

import it.apexnet.app.mortacci.R;
import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.MenuItem.OnMenuItemClickListener;
import android.widget.Toast;

public class NoConnectionActivity extends Activity{

	@Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        
        setContentView (R.layout.activity_no_connection);
        
        Toast.makeText(this, "No connection", Toast.LENGTH_SHORT).show();
	}
	
	@Override
	 public boolean onCreateOptionsMenu(Menu menu) {
		 super.onCreateOptionsMenu(menu);
		 
		 int order = Menu.FIRST;
		 
		 Intent creditsIntent = new Intent(this, CreditsActivity.class);
		 creditsIntent.setFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP);
		 
		 menu.add(0, 0, order++, "Credits").setIcon(R.drawable.credits).setIntent(creditsIntent);
			
		 menu.add(0, 0, order++, "Exit").setIcon(R.drawable.exit).setOnMenuItemClickListener(new OnMenuItemClickListener()
		 {

			public boolean onMenuItemClick(MenuItem arg0) {
				android.os.Process.killProcess(android.os.Process.myPid());
				return false;
			}
			 
		 });
		// Visualizziamo il Menu
		return true;
	 }
	
	@Override
	public void onDestroy()
	{
		super.onDestroy();		
		android.os.Process.killProcess(android.os.Process.myPid());
	}
}
