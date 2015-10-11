package com.{{_prj_.company}}.{{_prj_.name}}.event.{{_tbi_.mname}};

import com.argo.sdk.event.AppBaseEvent;

/**
 * PB{{_tbi_.mname}}删除事件
 * Created by {{_user_}} on {{_now_}}.
 */
public class PB{{_tbi_.entityName}}RemoveResultEvent extends AppBaseEvent {

    private PB{{_tbi_.entityName}} item;

    public PB{{_tbi_.entityName}}RemoveResultEvent(ApiError apiError) {
        super(apiError);
    }

    public PB{{_tbi_.entityName}}RemoveResultEvent(Exception ex) {
        super(ex);
    }

    public PB{{_tbi_.entityName}}RemoveResultEvent(PB{{_tbi_.entityName}} item) {
        this.item = item;
    }

    public PB{{_tbi_.entityName}} getItem() {
        return item;
    }

    public void setItem(PB{{_tbi_.entityName}} item) {
        this.item = item;
    }
}
