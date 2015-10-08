package com.kcompany.kproject.ui;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;

import com.argo.sdk.event.EventBus;
import com.argo.sdk.providers.LocationStatusProvider;
import com.argo.sdk.providers.UmengTrackProvider;
import com.argo.sdk.util.ImageUtils;

import butterknife.ButterKnife;
import timber.log.Timber;

import static android.content.Intent.FLAG_ACTIVITY_CLEAR_TOP;
import static android.content.Intent.FLAG_ACTIVITY_SINGLE_TOP;

/**
 * Base activity for a Bootstrap activity which does not use fragments.
 */
public abstract class BootstrapActivity extends Activity {

    @Override
    protected void onCreate(final Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        Timber.d("onCreate: %s", this);

        injectGraph();

        if (EventBus.instance != null) {
            EventBus.instance.register(this);
        }
    }

    @Override
    public void setContentView(final int layoutResId) {
        super.setContentView(layoutResId);
        // Used to inject views with the Butterknife library
        ButterKnife.inject(this);
    }

    /**
     * 注入服务
     */
    protected abstract void injectGraph();

    @Override
    protected void onResume() {
        super.onResume();

        Timber.d("onResume: %s", this);

        if (UmengTrackProvider.instance != null) {
            UmengTrackProvider.instance.resume();
            UmengTrackProvider.instance.pageStart(this.getClass().getSimpleName());
        }

        if (LocationStatusProvider.instance != null && LocationStatusProvider.instance.isFailure()){
            LocationStatusProvider.instance.restart();
        }
    }

    @Override
    protected void onPause() {
        super.onPause();

        Timber.d("onPause: %s", this);

        if (UmengTrackProvider.instance != null) {
            UmengTrackProvider.instance.pageEnd(this.getClass().getSimpleName());
            UmengTrackProvider.instance.pause();
        }
    }

    @Override
    protected void onRestart() {
        super.onRestart();

        Timber.d("onRestart: %s", this);

    }

    @Override
    protected void onStop() {
        super.onStop();

        Timber.d("onStop: %s", this);

    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        Timber.d("onDestroy: %s", this);
        if (EventBus.instance != null) {
            EventBus.instance.unregister(this);
        }
    }

    /**
     * 回收所有Bitmap
     * @param view
     */
    protected void cleanBitmaps(View view){
        try {
            if (view == null) {
                view = this.findViewById(android.R.id.content);
            }
            if (view instanceof ViewGroup) {
                ImageUtils.recycleAll((ViewGroup) view, true);
            }
        } catch (Exception e) {
            Timber.e(e, "recycle All Bitmap Error");
        }
    }

    @Override
    public boolean onOptionsItemSelected(final MenuItem item) {
        switch (item.getItemId()) {
            // This is the home button in the top left corner of the screen.
            case android.R.id.home:
                // Don't call finish! Because activity could have been started by an
                // outside activity and the home button would not operated as expected!
                final Intent homeIntent = new Intent(this, MainActivity.class);
                homeIntent.addFlags(FLAG_ACTIVITY_CLEAR_TOP | FLAG_ACTIVITY_SINGLE_TOP);
                startActivity(homeIntent);
                return true;
            default:
                return super.onOptionsItemSelected(item);
        }
    }
}
