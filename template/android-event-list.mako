package {{ _tbi_.android.event_ns }};

import com.argo.sdk.ApiError;
import com.argo.sdk.event.AppBaseEvent;
import {{ _tbi_.android.model_ns }}.{{_tbi_.pb.name}};

import java.util.List;

/**
 * {{_tbi_.pb.name}}列表读取事件
 * Created by {{_user_}}.
 */
public class {{_tbi_.pb.name}}ListResultEvent extends AppBaseEvent {

    private List<{{_tbi_.pb.name}}> list;
    private int page;

    public {{_tbi_.pb.name}}ListResultEvent(ApiError apiError) {
        super(apiError);
    }

    public {{_tbi_.pb.name}}ListResultEvent(Exception ex) {
        super(ex);
    }

    public {{_tbi_.pb.name}}ListResultEvent(List<{{_tbi_.pb.name}}> list, int page) {
        this.list = list;
        this.page = page;
    }

    public List<{{_tbi_.pb.name}}> getList() {
        return list;
    }

    public void setList(List<{{_tbi_.pb.name}}> list) {
        this.list = list;
    }

    public int getPage() {
        return page;
    }

    public void setPage(int page) {
        this.page = page;
    }
}
