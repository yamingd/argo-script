package com.{{prj.company}}.{{prj.name}}.event.{{_tbi_.mname}};

import com.argo.sdk.ApiError;
import com.argo.sdk.event.AppBaseEvent;
import com.{{prj.company}}.{{prj.name}}.protobuf.{{_tbi_.mname}}.PB{{_tbi_.mname}};

/**
 * PB{{_tbi_.mname}}详细读取事件
 * Created by {{_user_}} on {{_now_}}.
 */
public class PB{{_tbi_.entityName}}DetailResultEvent extends AppBaseEvent {

    private PB{{_tbi_.entityName}} item;

    public PB{{_tbi_.entityName}}DetailResultEvent(ApiError apiError) {
        super(apiError);
    }

    public PB{{_tbi_.entityName}}DetailResultEvent(Exception ex) {
        super(ex);
    }

    public PB{{_tbi_.entityName}}DetailResultEvent(PB{{_tbi_.entityName}} item) {
        this.item = item;
    }

    public PB{{_tbi_.entityName}} getItem() {
        return item;
    }

    public void setItem(PB{{_tbi_.entityName}} item) {
        this.item = item;
    }
}
