package {{ _tbi_.java.model_ns }};

import com.argo.annotation.Column;
import com.argo.annotation.Table;
import com.google.common.base.Objects;
import com.google.common.base.MoreObjects;
import org.msgpack.annotation.MessagePackMessage;
import java.util.Date;
import java.io.Serializable;


/**
 * {{ _tbi_.hint }}
 * Created by {{_user_}}.
 */
@Table("{{ _tbi_.name }}")
@MessagePackMessage
public class {{_tbi_.java.name }} extends Abstract{{ _tbi_.java.name }} {

}