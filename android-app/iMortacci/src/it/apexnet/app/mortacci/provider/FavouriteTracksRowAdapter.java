package it.apexnet.app.mortacci.provider;

import it.apexnet.app.mortacci.R;
import it.apexnet.app.mortacci.library.Album;
import it.apexnet.app.mortacci.provider.IMortacciDBContract.FavouriteTracksViewColumns;
import it.apexnet.app.mortacci.provider.IMortacciDBContract.Views;
import android.content.Context;
import android.database.Cursor;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.CursorAdapter;
import android.widget.Filter;
import android.widget.ImageView;
import android.widget.TextView;

public class FavouriteTracksRowAdapter extends CursorAdapter{
	
	private static final String TAG = "FavouriteTracksRowAdapter";
	private final LayoutInflater mInflater;	
	private IMortacciDBProvider db;	
	Filter newFilter;
	Cursor favouriteTracksCursor;
		
	public FavouriteTracksRowAdapter(Context context, Cursor c, IMortacciDBProvider _db) {
		super(context, c);		
		this.favouriteTracksCursor = c;
		this.mInflater = LayoutInflater.from(context);
		this.db = _db;
	}

	@Override
	public void bindView(View view, Context context, Cursor cursor) {

		TextView titleAlbum = (TextView)view.findViewById(R.id.album_title);		
		titleAlbum.setText(cursor.getString(
				cursor.getColumnIndex(FavouriteTracksViewColumns.ALBUM_TITLE)));
		
		Album a = new Album();
		a.slug = cursor.getString(
				cursor.getColumnIndex(FavouriteTracksViewColumns.ALBUM_SLUG));
		ImageView albumImage = (ImageView)view.findViewById(R.id.image_preview);			
		a.setImgAlbum(albumImage);
		
		TextView titleTracktTextView = (TextView)view.findViewById(R.id.title_track);
		titleTracktTextView.setText(cursor.getString(
				cursor.getColumnIndex(FavouriteTracksViewColumns.TRACK_TITLE)));
		
		
		TextView descriptionTrack = (TextView)view.findViewById(R.id.description_track);
		descriptionTrack.setText(cursor.getString(
				cursor.getColumnIndex(FavouriteTracksViewColumns.TRACK_DESCRIPTION)));			
	}

	@Override
	public View newView(Context context, Cursor cursor, ViewGroup parent) {
		
		final View view = this.mInflater.inflate(R.layout.list_item_favourite_tracks, parent, false);
		bindView(view, context, cursor);
		return view;
	}	
	
	@Override  
	public Cursor runQueryOnBackgroundThread(CharSequence constraint) {  
	    if(constraint == null) {  
	        return getCursor();  
	    }  
	              	  
	    Cursor c = db.query(false, Views.FAVOURITE_TRACKS_VIEW, FavouriteTracksViewColumns.COLUMNS , FavouriteTracksViewColumns.TRACK_TITLE + "LIKE %?%", new String[] {constraint.toString()}, null, null, null, null);
	    return c;  
	}  	
	
	@Override
    public Filter getFilter() {
        Log.d(TAG, "begin getFilter");
        if(newFilter == null) {
            newFilter = new Filter() {                
				@Override
                protected void publishResults(CharSequence constraint, FilterResults results) {
                    // TODO Auto-generated method stub
                    Log.d(TAG, "publishResults");    
                    //((Cursor)results.values).notify(); 
                    favouriteTracksCursor = ((Cursor)results.values);
                    //favouriteTracksCursor.requery();
                    changeCursor(favouriteTracksCursor);
                    notifyDataSetChanged();
                }

				@Override
				protected FilterResults performFiltering(CharSequence constraint) {
					// TODO Auto-generated method stub
					
					Cursor c = db.query(false, Views.FAVOURITE_TRACKS_VIEW, FavouriteTracksViewColumns.COLUMNS , FavouriteTracksViewColumns.TRACK_TITLE + " LIKE '%" + constraint.toString() + "%'" +
							" OR " + FavouriteTracksViewColumns.ALBUM_TITLE + " LIKE '%" + constraint.toString() + "%'" + 
							" OR " + FavouriteTracksViewColumns.TRACK_DESCRIPTION + " LIKE '%" + constraint.toString() + "%'",
								null, null, null, null, null);									
					FilterResults newFilterResults = new FilterResults();
					newFilterResults.count = c.getCount();
					newFilterResults.values = c;
					return newFilterResults;					
				}           
        };
    }
	    Log.d(TAG, "end getFilter");
	    return newFilter;
 	}
}
