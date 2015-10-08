package com.kcompany.kproject;

import android.support.v4.util.ArrayMap;

import com.argo.sdk.AppSession;
import com.argo.sdk.core.AppSecurity;

import java.util.Map;

/**
 * Created by user on 6/24/15.
 */
public final class GlobalVars {

    public static int AddMode = 3;
    public static String appName = "_project_";
    public static boolean debugOnRelease = false;
    public static boolean isRemoteProcess = false;

    public static void setValue(AppSession appSession){


    }

    public static AppSession appSession = null;
    public static AppSecurity appSecurity = null;

    public static final Map<String, Integer> iconMaps = new ArrayMap<String, Integer>();
    static {

    }
}
