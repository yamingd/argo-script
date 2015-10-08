package com.kcompany.kproject.ui;

import android.Manifest;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.Point;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.view.KeyEvent;
import android.view.View;
import android.view.WindowManager;
import android.view.inputmethod.InputMethodManager;
import android.widget.Toast;

import com.argo.sdk.AppSession;
import com.argo.sdk.FlashBucket;
import com.kcompany.kproject.GlobalVars;
import com.kcompany.kproject.R;
import com.kcompany.kproject.vendor.LoadToast;

import javax.inject.Inject;

/**
 * Created by Administrator on 2015/6/26 0026.
 */
public abstract class BaseActivity extends BootstrapActivity
        implements ActivityJumper {

    @Inject
    public AppSession appSession;

    @Inject
    public FlashBucket flashBucket;

    private int winWidth = 0;
    private int winHeight = 0;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setWinParams();

        if (null != savedInstanceState) {
            if (null != appSession) {
                GlobalVars.setValue(appSession);
            }
        }
    }

    @Override
    public void setContentView(int layoutResId) {
        super.setContentView(layoutResId);
        initNavHeader();
    }

    private void initNavHeader() {

    }

    private void setWinParams() {
        if (winHeight == 0 && winWidth == 0) { //避免重复执行
            //获取屏幕的高和框
            WindowManager wm = (WindowManager) getSystemService(Context.WINDOW_SERVICE);
            Point point = new Point();
            wm.getDefaultDisplay().getSize(point);

            winWidth = point.x;
            winHeight = point.y;
        }
    }

    public void startMyActivity(boolean userPrevNavTitle, Class clazz, Bundle extras, boolean showBack) {
        Intent intent = new Intent();
        if (null != extras) {
            intent.putExtras(extras);
        }

        intent.setClass(this, clazz);
        this.startActivity(intent);
    }

    @Override
    public void startMyActivity(Class clazz, Bundle extras) {
        this.startMyActivity(true, clazz, extras, true);
    }

    @Override
    public void startMyActivity(Class clazz, boolean showBack) {
        this.startMyActivity(true, clazz, null, showBack);
    }

    @Override
    public void startMyActivity(Class clazz, Bundle extras, boolean showBack) {
        this.startMyActivity(true, clazz, extras, showBack);
    }

    @Override
    public void startMyActivity(Class clazz) {
        this.startMyActivity(true, clazz, null, true);
    }

    @Override
    public void startMyActivity(boolean userPrevNavTitle, Class clazz) {
        this.startMyActivity(userPrevNavTitle, clazz, null, true);
    }

    @Override
    public void startMyActivityForResult(Class clazz, int requestCode) {
        this.startMyActivityForResult(clazz, null, requestCode);
    }

    @Override
    public void startMyActivityForResult(Class clazz, Bundle extras, int requestCode) {
        Intent intent = new Intent(this, clazz);
        if (null != extras) {
            intent.putExtras(extras);
        }
        this.startActivityForResult(intent, requestCode);
    }


    public void toast(String str) {
        Toast.makeText(this, str, Toast.LENGTH_SHORT).show();
    }

    public void toast(int res) {
        Toast.makeText(this, getResourceText(res), Toast.LENGTH_SHORT).show();
    }

    public void toast(String str, int duration) {
        Toast.makeText(this, str, duration).show();
    }

    protected LoadToast mLoadToast = null;

    public void toastLoad(String str) {
        if (mLoadToast == null) {
            mLoadToast = new LoadToast(this);
            mLoadToast.setTranslationY(getWinHeight() / 3);
            mLoadToast.setTextColor(this.getResources().getColor(R.color.white));
            mLoadToast.setBackgroundColor(this.getResources().getColor(R.color.c8));
        }
        mLoadToast.setText(str);
        mLoadToast.show();
    }

    public void toastLoadSuccess() {
        if (mLoadToast != null) {
            mLoadToast.success();
        }
    }

    public void toastLoadError() {
        if (mLoadToast != null) {
            mLoadToast.error();
        }
    }

    public void toastLoadError(String msg) {
        if (mLoadToast != null) {
            mLoadToast.setText(msg);
            mLoadToast.error();
        }
    }

    protected String getResourceText(int res, Object... args) {
        String text = (String) this.getResources().getText(res);
        return String.format(text, args);
    }

    protected int getResourceDimensionInt(int res) {
        float tmp = this.getResources().getDimension(res);
        return Float.valueOf(tmp).intValue();
    }

    /**
     * 退出app
     */
    protected void exitApp() {
        Intent intent = new Intent();
        intent.setClass(this, LoadingActivity.class);
        intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);  //注意本行的FLAG设置
        startActivity(intent);
        finish();//关掉自己
    }

    @Override
    protected void onResume() {
        super.onResume();
    }

    @Override
    public boolean onKeyUp(int keyCode, KeyEvent event) {
        if (keyCode == KeyEvent.KEYCODE_BACK && event.getRepeatCount() == 0) {
            // 按下的如果是BACK，同时没有重复
            if (keyCode == KeyEvent.KEYCODE_BACK && event.getRepeatCount() == 0) {
                onBackKeyClick();
            }
        }
        return true;
    }

    /**
     * 重复按返回键的回调事件
     */
    protected void onBackKeyClick() {
        this.finish();
    }

    /**
     * 隐藏软键盘
     * param context
     */
    public void hideKeyboard(Context context) {
        Activity activity = (Activity) context;
        if (activity != null) {
            InputMethodManager imm = (InputMethodManager) activity
                    .getSystemService(Context.INPUT_METHOD_SERVICE);
            if (imm.isActive() && activity.getCurrentFocus() != null) {
                imm.hideSoftInputFromWindow(activity.getCurrentFocus()
                        .getWindowToken(), 0);
            }
        }
    }

    public void clearCurrentFocus() {
        View currentFocus = this.getCurrentFocus();
        if (currentFocus != null) {
            currentFocus.clearFocus();
        }
    }

    /**
     * 显示软键盘
     */
    public static void showKeyboard(Context context) {
        Activity activity = (Activity) context;
        if (activity != null) {
            InputMethodManager imm = (InputMethodManager) activity
                    .getSystemService(Context.INPUT_METHOD_SERVICE);
            imm.showSoftInputFromInputMethod(activity.getCurrentFocus().getWindowToken(), 0);
            imm.toggleSoftInput(0, InputMethodManager.HIDE_NOT_ALWAYS);
        }
    }

    public int getWinWidth() {
        return winWidth;
    }

    public int getWinHeight() {
        return winHeight;
    }

    protected void callPhone(String number) {
        //用intent启动拨打电话
        Intent intent = new Intent(Intent.ACTION_CALL, Uri.parse("tel:" + number));
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            if (checkSelfPermission(Manifest.permission.CALL_PHONE) != PackageManager.PERMISSION_GRANTED) {
                // TODO: Consider calling
                //    public void requestPermissions(@NonNull String[] permissions, int requestCode)
                // here to request the missing permissions, and then overriding
                //   public void onRequestPermissionsResult(int requestCode, String[] permissions,
                //                                          int[] grantResults)
                // to handle the case where the user grants the permission. See the documentation
                // for Activity#requestPermissions for more details.
                return;
            }
        }
        startActivity(intent);
    }

    protected void returnToActivity(Class clazz) {
        Intent intent = new Intent(this, clazz);
        intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);  //注意本行的FLAG设置
        this.startActivity(intent);
        finish();
    }

    protected void returnToActivity(Class clazz, Bundle bundle) {
        Intent intent = new Intent(this, clazz);
        intent.putExtras(bundle);
        intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);  //注意本行的FLAG设置
        this.startActivity(intent);
        finish();
    }

//    /***
//     * 隐藏键盘
//     *
//     * @param event
//     * 抽象对象中不生效  //TODO
//     */
//    @Subscribe
//    public void onKeyboardOffEvent(KeyboardOffEvent event) {
//
//        hideKeyboard(this);
//        clearCurrentFocus();
//    }

}
