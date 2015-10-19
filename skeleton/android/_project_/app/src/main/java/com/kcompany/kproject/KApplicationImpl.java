package com.kcompany.kproject;

import android.app.ActivityManager;
import android.app.Application;
import android.content.Context;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;

import com.argo.sdk.AppSession;
import com.argo.sdk.BootConstants;
import com.argo.sdk.BootstrapApplication;
import com.argo.sdk.CrashHandler;
import com.argo.sdk.CrashUploadService;
import com.argo.sdk.DaggerBootstrapComponent;
import com.argo.sdk.FlashBucket;
import com.argo.sdk.core.AppSecurity;
import com.argo.sdk.http.APIClientProvider;
import com.argo.sdk.protobuf.PAppResponse;
import com.argo.sdk.providers.LocationStatusProvider;
import com.argo.sdk.providers.NetworkStatusProvider;
import com.argo.sdk.providers.UmengTrackProvider;
import com.argo.sdk.util.SDCardUtils;
import com.kcompany.kproject.ui.Injector;
import com.kcompany.kproject.ui.UIActivityModule;
import com.squareup.otto.Bus;
import com.squareup.picasso.Picasso;

import net.sqlcipher.database.SQLiteDatabase;

import java.io.IOException;
import java.util.List;

import javax.inject.Inject;

import timber.log.Timber;

/**
 * Created by user on 6/15/15.
 */
public class KApplicationImpl extends BootstrapApplication {

    @Inject
    AppSession appSession;

    @Inject
    APIClientProvider apiClientProvider;

    @Inject
    Bus bus;

    @Inject
    NetworkStatusProvider networkStatusProvider;

    @Inject
    LocationStatusProvider locationStatusProvider;

    @Inject
    UmengTrackProvider umengTrackProvider;

    @Inject
    SqliteCommonProvider sqliteCommonProvider;

    @Inject
    SqliteUserProvider sqliteUserProvider;

    @Inject
    FlashBucket flashBucket;

    @Inject
    Picasso picasso;

    @Inject
    AppSecurity appSecurity;

    private KComponent component;
    private UIActivityModule uiActivityModule;

    private static KApplicationImpl instance;

    @Override
    public void onCreate(){
        super.onCreate();
        instance = this;
    }

    @Override
    protected void onAfterInjection() {

        super.onAfterInjection();

        GlobalVars.appSession = appSession;
        GlobalVars.appSecurity = appSecurity;
        BootConstants.appSession = appSession;

        //TODO: call ModelInit
        //ModelInit.prepare();

        sqliteCommonProvider.get().clearTables();
        sqliteUserProvider.get().clearTables();

        // 判断是否是foreground-app
        locationStatusProvider.start();

        if (!appSession.isAnonymous()) {

        }

        CrashHandler.uploadLog(this);

    }

    public void closeDb(){
        //TODO: call ModelInit
        //ModelInit.reset();
        sqliteCommonProvider.close();
        sqliteUserProvider.close();
    }

    @Override
    public void onTerminate(){
        super.onTerminate();

        SQLiteDatabase.releaseMemory();
        appSecurity.clean();

        sqliteCommonProvider.close();
        sqliteUserProvider.close();
        try {
            appSession.close();
        } catch (IOException e) {
            Timber.e(e, "onTerminate");
        }

        System.exit(0);
    }

    @Override
    protected void initBeforeInject() {
        super.initBeforeInject();

        Timber.plant(new DebugReportTree());
        isIMProcess();

//        if (BuildConfig.DEBUG){
//            StrictMode.setThreadPolicy(new StrictMode.ThreadPolicy.Builder().detectAll().penaltyLog().build());
//            StrictMode.setVmPolicy(new StrictMode.VmPolicy.Builder().detectAll().penaltyLog().build());
//        }

        Timber.i("Application start. Build=%s, Process=%s", BuildConfig.DEBUG, getProcessName());

        final Application that = this;
        SQLiteDatabase.loadLibs(that);


        boolean crashUpload = false;
        try {
            ApplicationInfo appInfo = this.getPackageManager().getApplicationInfo(getPackageName(), PackageManager.GET_META_DATA);
            crashUpload = appInfo.metaData.getBoolean(".crashUpload");
            Timber.d("%s crashUpload: %s", this, crashUpload);
        } catch (PackageManager.NameNotFoundException e) {

        }

        Object[] info = BootConstants.getCpuArchitecture();
        Timber.d("cpu: %s, %s, %s", info[0], info[1], info[2]);

        BootConstants.DEBUG = BuildConfig.DEBUG;
        BootConstants.pringHttpTS = !crashUpload;
        SQLiteDatabase.printSQLTS = !crashUpload;
        BootConstants.setAppName("_project_");
        SDCardUtils.ensureRootFolder(getApplicationContext());
        CrashUploadService.uploadUrl = "/m/crash/collect/android";

        if (crashUpload) {
            CrashHandler crashHandler = CrashHandler.getInstance();
            crashHandler.init(getApplicationContext());
        }

        uiActivityModule = new UIActivityModule();
        component = DaggerKComponent.builder().bootstrapComponent(DaggerBootstrapComponent.create()).uIActivityModule(uiActivityModule).build();
        component.inject(this);
        Injector.init(component, uiActivityModule);
    }

    private String getProcessName(){
        String currentProcName = "";
        int pid = android.os.Process.myPid();
        ActivityManager manager = (ActivityManager) this.getSystemService(Context.ACTIVITY_SERVICE);
        for (ActivityManager.RunningAppProcessInfo processInfo : manager.getRunningAppProcesses())
        {
            if (processInfo.pid == pid)
            {
                currentProcName = processInfo.processName;
                break;
            }
        }
        return currentProcName;
    }

    private boolean isIMProcess(){
        String name = getProcessName();
        GlobalVars.isRemoteProcess = name.endsWith(":remote");
        return GlobalVars.isRemoteProcess;
    }


    @Override
    protected AppSession getAppSession() {
        return this.appSession;
    }

    @Override
    protected Bus getBus() {
        return this.bus;
    }

    @Override
    protected NetworkStatusProvider getNetworkStatusProvider() {
        return this.networkStatusProvider;
    }


    private static class DebugReportTree extends Timber.DebugTree{

        @Override
        public void d(String message, Object... args) {
            if (!BuildConfig.DEBUG){
                if (!GlobalVars.debugOnRelease) {
                    return;
                }
            }
            super.d(message, args);
        }

        @Override
        public void d(Throwable t, String message, Object... args) {
            if (!BuildConfig.DEBUG){
                if (!GlobalVars.debugOnRelease) {
                    return;
                }
            }
            super.d(t, message, args);
        }

        @Override
        public void v(String message, Object... args) {
            if (!BuildConfig.DEBUG){
                if (!GlobalVars.debugOnRelease) {
                    return;
                }
            }
            super.v(message, args);
        }

        @Override
        public void v(Throwable t, String message, Object... args) {
            if (!BuildConfig.DEBUG){
                if (!GlobalVars.debugOnRelease) {
                    return;
                }
            }
            super.v(t, message, args);
        }

        @Override protected synchronized void log(int priority, String tag, String message, Throwable t) {

            message = String.format("%s %s", Thread.currentThread(), message);

            super.log(priority, tag, message, t);

        }
    }

    public static KApplicationImpl getInstance() {
        return instance;
    }
}
