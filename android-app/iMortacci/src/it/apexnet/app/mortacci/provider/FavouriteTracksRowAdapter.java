package it.apexnet.app.mortacci.provider;

import it.apexnet.app.mortacci.R;
import it.apexnet.app.mortacci.library.Album;
import it.apexnet.app.mortacci.provider.IMortacciDBContract.FavouriteTracksViewColumns;
import android.content.Context;
import android.database.Cursor;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.CursorAdapter;
import android.widget.ImageView;
import android.widget.TextView;

public class FavouriteTracksRowAdapter extends CursorAdapter{
	
	private final LayoutInflater mInflater;
	
	public FavouriteTracksRowAdapter(Context context, Cursor c) {
		super(context, c);
		this.mInflater = LayoutInflater.from(context);
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
}
