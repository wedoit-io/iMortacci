package it.apexnet.app.mortacci.provider;

import it.apexnet.app.mortacci.R;
import it.apexnet.app.mortacci.library.Album;
import it.apexnet.app.mortacci.library.Track;
import android.content.Context;
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
	
	public TracksArrayAdapter(Context context, Album _album)
	{
		super (context, R.layout.list_item_albums, R.id.title_album);
		this.album = _album;
		this.mInflater = LayoutInflater.from(context);		
	}
	
	 public int getCount() {
        return this.getCount();
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
		Track item = getItem (position);
		viewHolder.TrackTitleTextView.setText(item.title);
		viewHolder.PlaybackCountTextView.setText(String.valueOf(item.playbackCount) + " ascolti");
		this.album.setImgAlbum(viewHolder.TrackImageView);
		return convertView;
	}
	 
 	
 	@Override
    public Filter getFilter() {
        /*Log.d(TAG, "begin getFilter");
        if(newFilter == null) {
            newFilter = new Filter() {
                @Override
                protected void publishResults(CharSequence constraint, FilterResults results) {
                    // TODO Auto-generated method stub
                    Log.d(TAG, "publishResults");
                    notifyDataSetChanged();
                }


            @Override
            protected FilterResults performFiltering(CharSequence constraint) {
                Log.d(TAG, "performFiltering");

                constraint = constraint.toString().toLowerCase();
                Log.d(TAG, "constraint : "+constraint);

                List<ChatObject> filteredFriendList = new LinkedList<ChatObject>();

                for(int i=0; i<friendList.size(); i++) {
                    Friend newFriend = friendList.get(i);
                    Log.d(TAG, "displayName : "+newFriend.getDisplayName().toLowerCase());
                    if(newFriend.getDisplayName().toLowerCase().contains(constraint)) {
                        Log.d(TAG, "equals : "+newFriend.getDisplayName());
                        filteredFriendList.add(newFriend);
                    }
                }

                FilterResults newFilterResults = new FilterResults();
                newFilterResults.count = filteredFriendList.size();
                newFilterResults.values = filteredFriendList;
                return newFilterResults;
            }
        };
    }
	    Log.d(TAG, "end getFilter");*/
	    return newFilter;
 	}
	 
	 private static class ViewHolder
	 {
		public TextView TrackTitleTextView;    	
		public TextView PlaybackCountTextView;
		public ImageView TrackImageView;
	}
}
