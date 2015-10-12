package com.{{prj._company_}}.{{prj._name_}}.event.{{_tbi_.mname}};

import com.argo.sdk.ApiError;
import com.argo.sdk.event.AppBaseEvent;
import com.{{prj._company_}}.{{prj._name_}}.protobuf.{{_tbi_.mname}}.PB{{_tbi_.entityName}};

import java.util.List;

/**
 * PB{{_tbi_.mname}}列表读取事件
 * Created by {{_user_}} on {{_now_}}.
 */
public class PB{{_tbi_.entityName}}ListResultEvent extends AppBaseEvent {

    private List<PB{{_tbi_.entityName}}> list;
    private int page;

    public PB{{_tbi_.entityName}}ListResultEvent(ApiError apiError) {
        super(apiError);
    }

    public PB{{_tbi_.entityName}}ListResultEvent(Exception ex) {
        super(ex);
    }

    public PB{{_tbi_.entityName}}ListResultEvent(List<PB{{_tbi_.entityName}}> list, int page) {
        this.list = list;
        this.page = page;
    }

    public List<PB{{_tbi_.entityName}}> getList() {
        return list;
    }

    public void setList(List<PB{{_tbi_.entityName}}> list) {
        this.list = list;
    }

    public int getPage() {
        return page;
    }

    public void setPage(int page) {
        this.page = page;
    }
}
