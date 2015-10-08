package com.kcompany.kproject.ui;

import android.os.Bundle;

/**
 * Created by _user_.
 */
public interface ActivityJumper {

    /**
     *
     * @param clazz
     * @param extras
     */
    void startMyActivity(Class clazz, Bundle extras);

    /**
     *
     * @param clazz
     * @param showBack
     */
    void startMyActivity(Class clazz, boolean showBack);

    /**
     *
     * @param clazz
     * @param extras
     * @param showBack
     */
    void startMyActivity(Class clazz, Bundle extras, boolean showBack);

    /**
     *
     * @param clazz
     */
    void startMyActivity(Class clazz);

    /**
     *
     * @param userPrevNavTitle
     * @param clazz
     */
    void startMyActivity(boolean userPrevNavTitle, Class clazz);

    /**
     *
     * @param clazz
     * @param requestCode
     */
    void startMyActivityForResult(Class clazz, int requestCode);

    /**
     *
     * @param clazz
     * @param extras
     * @param requestCode
     */
    void startMyActivityForResult(Class clazz, Bundle extras, int requestCode);
}
