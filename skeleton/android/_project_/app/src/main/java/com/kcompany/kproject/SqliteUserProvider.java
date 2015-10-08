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
public class SqliteUserProvider implements Provider<SqliteContext> {

    private SqliteContext sqliteContext;
    private Context context;
    private AppSession appSession;

    public SqliteUserProvider(Context context, AppSession appSession) {
        this.context = context;
        this.appSession = appSession;
        get();
    }

    @Override
    public synchronized SqliteContext get() {

        if (null == sqliteContext){
            sqliteContext = new SqliteContext(this.context, appSession.getSalt());
            sqliteContext.setTag("default");

            SqliteEngine.add(sqliteContext);
        }

        sqliteContext.setUserId(appSession.get().getUserId() + "");

        Timber.d("%s SqliteUserProvider, %s", this, sqliteContext);

        return sqliteContext;
    }

    /**
     *
     * @return
     */
    public synchronized void reset(boolean signIn){
        close();
        if (signIn) {
            get();
            //TODO: call ModelInit
            //ModelInit.prepare();
            sqliteContext.clearTables();
        }
    }

    /**
     *
     */
    public void close(){

        if (sqliteContext != null) {
            sqliteContext.close();
        }

        //TODO: call ModelInit
        //ModelInit.reset();
    }

}
