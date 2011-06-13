package it.apexnet.app.mortacci.provider;

import it.apexnet.app.mortacci.R;
import it.apexnet.app.mortacci.library.Album;
import it.apexnet.app.mortacci.library.Track;
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

		TextView titleTrack = (TextView)view.findViewById(R.id.title_track);
		
		titleTrack.setText(cursor.getString(
									cursor.getColumnIndex(FavouriteTracksViewColumns.TRACK_TITLE)));
		
		Album a = new Album();
		a.slug = cursor.getString(
					cursor.getColumnIndex(FavouriteTracksViewColumns.ALBUM_SLUG));
		ImageView albumImage = (ImageView)view.findViewById(R.id.image_preview);			
		a.setImgAlbum(albumImage);
		
		
		TextView playCountTextView = (TextView)view.findViewById(R.id.playback_count);
		playCountTextView.setText(cursor.getString(
											cursor.getColumnIndex(FavouriteTracksViewColumns.TRACK_PLAYBACK_COUNT)));
	}

	@Override
	public View newView(Context context, Cursor cursor, ViewGroup parent) {
		
		final View view = this.mInflater.inflate(R.layout.list_item_tracks, parent, false);
		bindView(view, context, cursor);
		return view;
	}	
}
