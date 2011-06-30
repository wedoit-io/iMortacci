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
		
	public SQLiteDatabase getWritableDatabase()
	{
		return this.dbHelper.getWritableDatabase();
	}
	
	public Cursor query (boolean distinct, String table, String [] columns, String selection,
						String [] selectionArgs, String groupBy, String having, String orderBy,
						String limit)
	{	
		
		SQLiteDatabase database = getWritableDatabase();
		Cursor cursor = database.query(distinct, table, columns, selection, selectionArgs, groupBy, having, orderBy, limit);
		//database.close();
		return cursor;
	}
	
	public long insert (String table, String nullColumnHack, ContentValues values)
	{		
		return getWritableDatabase().insert(table, nullColumnHack, values);
		/*
		SQLiteDatabase database = getWritableDatabase();
		long _id = database.insert(table, nullColumnHack, values);
		database.close();
		return _id;*/		
	}
	
	public int delete (String table, String whereClause, String [] whereArgs)
	{
		SQLiteDatabase database = getWritableDatabase();
		int count = database.delete(table, whereClause, whereArgs);
		//database.close();
		return count;
	}	
	
	public void close()
	{		
		this.dbHelper.close();
	}
}
