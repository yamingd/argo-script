package com.kcompany.kproject;

import android.net.wifi.WifiManager;

import com.argo.sdk.AppScope;
import com.argo.sdk.AppSession;
import com.argo.sdk.BootstrapComponent;
import com.argo.sdk.FlashBucket;
import com.argo.sdk.http.APIClientProvider;
import com.argo.sdk.providers.UmengTrackProvider;
import com.kcompany.kproject.ui.UIActivityComponent;
import com.kcompany.kproject.ui.UIActivityModule;
import com.kcompany.kproject.ui.UIPresenterModule;

import dagger.Component;

/**
 * Created by user on 6/15/15.
 */
@AppScope
@Component(
        dependencies = BootstrapComponent.class,
        modules = {
                CoreModule.class,
                UIPresenterModule.class,
                UIActivityModule.class
        }
)
public interface KComponent {

        UIActivityComponent uiActivityComponent(UIActivityModule uiActivityModule);
        KApplicationImpl inject(KApplicationImpl application);

        AppSession appSession();
        APIClientProvider apiClientProvider();
        UmengTrackProvider umengTrackProvider();
        FlashBucket flashBucket();
        WifiManager wifiManager();
}
