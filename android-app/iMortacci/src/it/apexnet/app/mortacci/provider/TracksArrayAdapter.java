package it.apexnet.app.mortacci.provider;

import java.util.ArrayList;
import it.apexnet.app.mortacci.R;
import it.apexnet.app.mortacci.library.Album;
import it.apexnet.app.mortacci.library.Track;
import android.content.Context;
import android.util.Log;
import android.view.LayoutInflater;

import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.Filter;
import android.widget.Filterable;
import android.widget.ImageView;
import android.widget.TextView;

public class TracksArrayAdapter extends ArrayAdapter<Track> implements Filterable{
	private static final String TAG = "TracksArrayAdapter";
	private LayoutInflater mInflater; 	
	Album album;
	Filter newFilter;
	ArrayList<Track> subTracks;
	ArrayList<Track> allTracks;
	
	
	public TracksArrayAdapter(Context context, Album _album, LayoutInflater _mInflater)
	{		
		super (context, R.layout.list_item_tracks, R.id.title_track, _album.tracks);
		this.subTracks = _album.tracks;
		this.allTracks =  new ArrayList<Track>();		
		
		for (Track t : _album.tracks)
			this.allTracks.add(t);
		
		this.album = _album;
		this.mInflater =_mInflater;	
	}
		
	 
 	@Override
	public View getView (int position, View convertView, ViewGroup parent)
	{
		ViewHolder viewHolder = null;
		if (convertView == null)
		{			
			convertView = this.mInflater.inflate(R.layout.list_item_tracks, null);
			viewHolder = new ViewHolder();
			viewHolder.TrackTitleTextView = (TextView)convertView.findViewById(R.id.title_track);
			viewHolder.PlaybackCountTextView = (TextView)convertView.findViewById(R.id.playback_count);
			viewHolder.TrackImageView = (ImageView)convertView.findViewById(R.id.image_preview);
			convertView.setTag(viewHolder);
		}
		else
		{
			viewHolder = (ViewHolder)convertView.getTag();
		}
		Track item = subTracks.get (position);
		viewHolder.TrackTitleTextView.setText(item.title);
		viewHolder.PlaybackCountTextView.setText(String.valueOf(item.playbackCount) + " ascolti");
		this.album.setImgAlbum(viewHolder.TrackImageView);
		return convertView;
	}
	 
 	
 	@Override
    public Filter getFilter() {
        Log.d(TAG, "begin getFilter");
        //if(newFilter == null) {
            newFilter = new Filter() {
                @SuppressWarnings("unchecked")
				@Override
                protected void publishResults(CharSequence constraint, FilterResults results) {
                    // TODO Auto-generated method stub
                    Log.d(TAG, "publishResults");  
                    subTracks = (ArrayList<Track>)results.values;
                    clear();
                    
                    for (Track t : subTracks)
                    	add (t);
                    
                    notifyDataSetChanged();
                }


            @Override
            protected FilterResults performFiltering(CharSequence constraint) {
                Log.d(TAG, "performFiltering");

                constraint = constraint.toString().toLowerCase();
                Log.d(TAG, "constraint : "+constraint);

                ArrayList<Track> filteredTracksList = new ArrayList<Track>();

                Log.d(TAG, "size : "+ allTracks.size());
                
                for(int i=0; i<allTracks.size(); i++) {
                    Track newTrack = allTracks.get(i);
                    
                    if(newTrack.title.toLowerCase().contains(constraint)) {
                        Log.d(TAG, "equals : "+ newTrack.title + " - " + constraint);
                        filteredTracksList.add(newTrack);
                    }
                }

                FilterResults newFilterResults = new FilterResults();
                newFilterResults.count = filteredTracksList.size();
                newFilterResults.values = filteredTracksList;                
                return newFilterResults;
            }
        };
    //}
	    Log.d(TAG, "end getFilter");
	    return newFilter;
 	}
	 
	 private static class ViewHolder
	 {
		public TextView TrackTitleTextView;    	
		public TextView PlaybackCountTextView;
		public ImageView TrackImageView;
	}
}
