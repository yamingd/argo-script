package com.kcompany.kproject.ui;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.util.AttributeSet;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.Toast;

import com.kcompany.kproject.R;
import com.kcompany.kproject.vendor.LoadToast;

import butterknife.ButterKnife;
import timber.log.Timber;

/**
 * Created by Administrator on 2015/7/7 0007.
 */
public abstract class BaseLayout extends LinearLayout implements ActivityJumper {

    public BaseLayout(Context context) {
        super(context);
        injectGraph();
    }

    public BaseLayout(Context context, AttributeSet attrs) {
        super(context, attrs);
        injectGraph();
    }

    public BaseLayout(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        injectGraph();
    }

    /**
     *
     */
    protected abstract void injectGraph();

    protected View inflate(int resource) {
        View view = inflate(getContext(), resource, this);

        // Used to inject views with the Butterknife library
        ButterKnife.inject(this);
        return view;
    }

    @Override
    public void startMyActivity(Class clazz) {
        startMyActivity(clazz, null, true);
    }

    @Override
    public void startMyActivity(Class clazz, Bundle extras, boolean showBack) {
        Intent intent = new Intent();
        if (null != extras) {
            intent.putExtras(extras);
        }
        String navTitle = getNavTitle();
        intent.setClass(this.getContext(), clazz);
        this.getContext().startActivity(intent);
    }

    @Override
    public void startMyActivity(Class clazz, Bundle extras) {
        this.startMyActivity(clazz, extras, true);
    }

    @Override
    public void startMyActivity(Class clazz, boolean showBack) {
        this.startMyActivity(clazz, null, showBack);
    }

    @Override
    public void startMyActivity(boolean userPrevNavTitle, Class clazz) {
        Timber.e("NOT SUPPORT!");
    }

    @Override
    public void startMyActivityForResult(Class clazz, int requestCode) {
        Timber.e("NOT SUPPORT!");
    }

    @Override
    public void startMyActivityForResult(Class clazz, Bundle extras, int requestCode) {
        Timber.e("NOT SUPPORT!");
    }

    /**
     * 获取每个页的nav header 名称，跳转到下一个页面时替换返回文字
     * @return
     */
    public String getNavTitle() {
        return null;
    }

    protected LoadToast mLoadToast =null;
    public void toastLoad(String str){
        if(mLoadToast == null ){
            mLoadToast = new LoadToast(this.getContext());
            mLoadToast.setTranslationY(400);
            mLoadToast.setTextColor(this.getResources().getColor(R.color.white));
            mLoadToast.setBackgroundColor(this.getResources().getColor(R.color.c8));
        }
        mLoadToast.setText(str);
        mLoadToast.show();
    }

    public void toastLoadSuccess(){
        if(mLoadToast!=null){
            mLoadToast.success();
        }
    }

    public void toastLoadError(){
        if(mLoadToast!=null){
            mLoadToast.error();
        }
    }
    public void toast(String str) {
        Toast.makeText(this.getContext(),str,Toast.LENGTH_SHORT).show();
    }

    public void toast(int res) {
        Toast.makeText(this.getContext(), getResourceText(res), Toast.LENGTH_SHORT).show();
    }

    protected String getResourceText(int res, Object... args) {
        String text = (String) this.getContext().getResources().getText(res);
        return String.format(text, args);
    }

    protected String getString(int resourceId) {
        return this.getResources().getString(resourceId);
    }

//    public abstract void refresh();

}
