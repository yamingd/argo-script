package com.kcompany.kproject;

import android.content.Context;
import android.net.wifi.WifiManager;

import com.argo.sdk.AppScope;
import com.argo.sdk.AppSession;
import com.argo.sdk.cache.CacheProvider;
import com.argo.sdk.core.AppSecurity;
import com.argo.sdk.http.APIClientProvider;
import com.argo.sdk.providers.UmengTrackProvider;
import com.argo.sdk.providers.UserAgentProvider;
import com.argo.sdk.AppSessionSqliteImpl;
import com.squareup.otto.Bus;

import dagger.Module;
import dagger.Provides;

/**
 * Created by _user_ on.
 */
@Module
public class CoreModule {

        @Provides
        @AppScope
        SqliteCommonProvider provideSqliteCommonProvider(Context context, AppSession appSession){
                return new SqliteCommonProvider(context, appSession);
        }

        @Provides
        @AppScope
        SqliteUserProvider provideSqliteUserProvider(Context context, AppSession appSession){
                return new SqliteUserProvider(context, appSession);
        }

        @Provides
        @AppScope
        AppSecurity provideAppSecurity(Context context){
                return new AppSecurity(context);
        }


        @AppScope
        @Provides
        AppSession provideAppSession(AppSessionSqliteImpl appSessionImpl) {
                return appSessionImpl;
        }

        @AppScope
        @Provides
        APIClientProvider provideAPIClientProvider(final Context context, AppSession appSession,
                                                   UserAgentProvider userAgentProvider,
                                                   CacheProvider cacheProvider,
                                                   WifiManager wifiManager){

                return new APIClientProvider(appSession, userAgentProvider, context, cacheProvider, wifiManager);
        }

        @AppScope
        @Provides
        UmengTrackProvider provideUmengTrackProvider(final Context context, AppSession appSession){
                return new UmengTrackProvider(context, appSession);
        }

}
