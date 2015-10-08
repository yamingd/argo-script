package com.kcompany.kproject.ui;

import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;

import com.kcompany.kproject.KApplicationImpl;
import com.kcompany.kproject.R;

import timber.log.Timber;

public class LoadingActivity extends BaseActivity {
    String channel;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        channel = appSession.getConfigValue("Channel", "");
        setContentView(R.layout.activity_loading);

    }

    @Override
    protected void onResume() {
        super.onResume();

        if ("qqstore".equals(channel)) {
            new Handler().postDelayed(new Runnable() {
                @Override
                public void run() {
                    toHomePage();
                }
            }, 1500);
        } else {
            toHomePage();
        }
    }

    private void toHomePage() {

    }

    @Override
    protected void onStop() {
        super.onStop();

        this.cleanBitmaps(null);
    }

    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        Timber.d("%s, onNewIntent intent=%s", this, intent);
        if ((Intent.FLAG_ACTIVITY_CLEAR_TOP & intent.getFlags()) != 0) {
            KApplicationImpl.getInstance().closeDb();
            Timber.d("%s, 结束APP... onNewIntent intent=%s", this, intent);
            finish();
        } else {
            Timber.d("%s, 退出帐号... onNewIntent intent=%s", this, intent);
            toHomePage();
        }
    }

    @Override
    protected void injectGraph() {
        Injector.get().inject(this);
    }
}
