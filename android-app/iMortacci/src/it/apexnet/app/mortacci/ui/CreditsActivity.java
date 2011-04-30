package it.apexnet.app.mortacci.ui;

import it.apexnet.app.mortacci.R;
import android.app.Activity;
import android.os.Bundle;
import android.widget.TextView;

public class CreditsActivity extends Activity{

	@Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        
        setContentView (R.layout.activity_credits);
        ((TextView) findViewById(R.id.title_text)).setText(getTitle());
	}	
}
