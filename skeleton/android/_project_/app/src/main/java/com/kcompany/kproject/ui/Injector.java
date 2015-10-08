package com.kcompany.kproject.ui;

import android.support.v4.util.ArrayMap;

import com.kcompany.kproject.KComponent;

import java.lang.reflect.Method;
import java.util.Map;

/**
 * Created by user on 7/11/15.
 */
public final class Injector {

    public static final String INJECT = "inject";

    private static UIActivityComponent injector = null;
    private static Map<Class, Method> methods = new ArrayMap<Class, Method>();

    public static void init(KComponent base, UIActivityModule uiActivityModule){

        injector = base.uiActivityComponent(uiActivityModule);
    }

    public static UIActivityComponent get(){
        return injector;
    }

}
