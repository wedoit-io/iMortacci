package it.apexnet.app.mortacci.widget;

import android.app.Activity;
import android.view.Gravity;

import com.google.ads.AdSize;
import com.google.ads.AdView;

public class AdViewLoader extends AdView{
	
	private static final String MY_AD_UNIT_ID = "a14db7cdb865c39"; 
	
	public AdViewLoader(Activity activity, AdSize adSize) {		
		super(activity, adSize, MY_AD_UNIT_ID);				
		setGravity(Gravity.CENTER);
	}
}
