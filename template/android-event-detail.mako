package {{ _tbi_.android.event_ns }};

import com.argo.sdk.ApiError;
import com.argo.sdk.event.AppBaseEvent;
import {{ _tbi_.android.model_ns }}.{{_tbi_.pb.name}};

/**
 * {{_tbi_.pb.name}}详细读取事件
 * Created by {{_user_}}.
 */
public class {{_tbi_.pb.name}}DetailResultEvent extends AppBaseEvent {

    private {{_tbi_.pb.name}} item;

    public {{_tbi_.pb.name}}DetailResultEvent(ApiError apiError) {
        super(apiError);
    }

    public {{_tbi_.pb.name}}DetailResultEvent(Exception ex) {
        super(ex);
    }

    public {{_tbi_.pb.name}}DetailResultEvent({{_tbi_.pb.name}} item) {
        this.item = item;
    }

    public {{_tbi_.pb.name}} getItem() {
        return item;
    }

    public void setItem({{_tbi_.pb.name}} item) {
        this.item = item;
    }
}
