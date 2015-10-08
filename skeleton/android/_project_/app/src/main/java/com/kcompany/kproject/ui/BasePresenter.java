package com.kcompany.kproject.ui;

import android.app.Activity;
import android.view.View;

/**
 * Created by user on 7/2/15.
 */
public abstract class BasePresenter {

    public static class FormValidationResult{

        private boolean error;
        private String msg;

        public FormValidationResult(boolean error) {
            this.error = error;
            this.msg = msg;
        }

        public boolean isError() {
            return error;
        }

        public String getMsg() {
            return msg;
        }

        public void setMsg(String msg) {
            this.msg = msg;
        }
    }

    public final FormValidationResult SUCCESS = new FormValidationResult(false);
    public final FormValidationResult ERROR = new FormValidationResult(true);

    protected View view;
    protected Activity activity;

    public void setView(View view) {
        this.view = view;
    }

    public void setActivity(Activity activity) {
        this.activity = activity;
    }

    public FormValidationResult submitForm(){
        return SUCCESS;
    }

    public void reset(){

    }
}
