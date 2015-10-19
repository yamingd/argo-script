package com._company_._project_;

/**
 * Created by _user_.
 */
public final class Devivces {

    public static final int iOSApp = 1;

    public static final int PCWeb = 2;

    public static final int AndroidApp = 3;

    public static final int WeixinApp = 4;

    public static int get(String userAgent){

        if (userAgent.contains("Android")){
            return AndroidApp;
        }else if (userAgent.contains("iPhone") || userAgent.contains("iPad")){
            return iOSApp;
        }else if (userAgent.contains("MicroMessenger")){
            return WeixinApp;
        }else{
            return PCWeb;
        }

    }
}
