package com.{{prj._company_}}.{{prj._name_}}.event.{{_tbi_.package}};

import com.argo.sdk.event.AppBaseEvent;
import com.argo.sdk.ApiError;
import com.{{prj._company_}}.{{prj._name_}}.protobuf.{{_tbi_.package}}.{{_tbi_.pb.name}};

/**
 * {{_tbi_.pb.name}}删除事件
 * Created by {{_user_}} on {{_now_}}.
 */
public class {{_tbi_.pb.name}}RemoveResultEvent extends AppBaseEvent {

    private {{_tbi_.pb.name}} item;

    public {{_tbi_.pb.name}}RemoveResultEvent(ApiError apiError) {
        super(apiError);
    }

    public {{_tbi_.pb.name}}RemoveResultEvent(Exception ex) {
        super(ex);
    }

    public {{_tbi_.pb.name}}RemoveResultEvent({{_tbi_.pb.name}} item) {
        this.item = item;
    }

    public {{_tbi_.pb.name}} getItem() {
        return item;
    }

    public void setItem({{_tbi_.pb.name}} item) {
        this.item = item;
    }
}
