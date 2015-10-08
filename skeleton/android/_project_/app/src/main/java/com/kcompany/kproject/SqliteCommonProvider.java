package com.kcompany.kproject;

import android.content.Context;

import com.argo.sqlite.SqliteContext;
import com.argo.sqlite.SqliteEngine;
import com.argo.sdk.AppSession;

import javax.inject.Provider;

import timber.log.Timber;

/**
 * Created by user on 8/15/15.
 */
public class SqliteCommonProvider implements Provider<SqliteContext> {

    private SqliteContext sqliteContext;
    private Context context;
    private AppSession appSession;
    private boolean inited = false;

    public SqliteCommonProvider(Context context, AppSession appSession) {
        this.context = context;
        this.appSession = appSession;

        get();
    }

    @Override
    public synchronized SqliteContext get() {

        if (null == sqliteContext){

            sqliteContext = new SqliteContext(this.context, "common", appSession.getSalt());
            sqliteContext.setTag("common");
            inited = sqliteContext.exists();

            SqliteEngine.add(sqliteContext);

            Timber.i("Common Db exists=. %s", inited);
        }

        return sqliteContext;
    }

    public boolean isInited() {
        return inited;
    }

    public void reopen(){
        if (sqliteContext != null){
            sqliteContext.reopen();
        }
    }

    /**
     *
     */
    public void close(){

        if (sqliteContext != null) {
            sqliteContext.close();
        }

    }
}
