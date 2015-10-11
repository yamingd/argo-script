package com.{{_prj_.company}}.{{_prj_.name}}.event.{{_tbi_.mname}};

import com.argo.sdk.event.AppBaseEvent;

/**
 * PB{{_tbi_.mname}}保存事件
 * Created by {{_user_}} on {{_now_}}.
 */
public class PB{{_tbi_.entityName}}SaveResultEvent extends AppBaseEvent {

    private PB{{_tbi_.entityName}} item;

    public PB{{_tbi_.entityName}}SaveResultEvent(ApiError apiError) {
        super(apiError);
    }

    public PB{{_tbi_.entityName}}SaveResultEvent(Exception ex) {
        super(ex);
    }

    public PB{{_tbi_.entityName}}SaveResultEvent(PB{{_tbi_.entityName}} item) {
        this.item = item;
    }

    public PB{{_tbi_.entityName}} getItem() {
        return item;
    }

    public void setItem(PB{{_tbi_.entityName}} item) {
        this.item = item;
    }
}
