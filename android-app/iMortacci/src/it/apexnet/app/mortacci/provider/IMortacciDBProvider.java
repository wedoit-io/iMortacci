package it.apexnet.app.mortacci.provider;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;


/**
 * Provider that stores {@link IMortacciDBContract} data.
 */

public class IMortacciDBProvider {

	private final IMortacciDB  dbHelper;
	
	public IMortacciDBProvider (Context context)
	{
		this.dbHelper = new IMortacciDB(context);
	}
	
	public Cursor query (boolean distinct, String table, String [] columns, String selection,
						String [] selectionArgs, String groupBy, String having, String orderBy,
						String limit)
	{
		final SQLiteDatabase db = this.dbHelper.getWritableDatabase();
		
		return db.query(distinct, table, columns, selection, selectionArgs, groupBy, having, orderBy, limit);
	}
	
	public long insert (String table, String nullColumnHack, ContentValues values)
	{
		final SQLiteDatabase db = this.dbHelper.getWritableDatabase();
		return db.insert(table, nullColumnHack, values);
	}
	
	public void close()
	{
		this.dbHelper.close();
	}
}
