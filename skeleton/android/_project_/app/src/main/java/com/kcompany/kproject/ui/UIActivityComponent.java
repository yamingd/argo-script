package com.kcompany.kproject.ui;

import com.argo.sdk.AppScope;

import dagger.Subcomponent;

/**
 * Created by user on 7/11/15.
 */
@AppScope
@Subcomponent(
        modules = {
                UIActivityModule.class
        }
)
public interface UIActivityComponent{

        void inject(MainActivity mainActivity);
        void inject(BaseActivity baseActivity);

}
