package com.{{prj._company_}}.{{prj._name_}}.model.{{_module_}};

import com.argo.annotation.Column;
import com.argo.annotation.Table;
import com.google.common.base.Objects;
import org.msgpack.annotation.MessagePackMessage;
import java.util.Date;
import java.io.Serializable;

/**
 * {{ _tbi_.hint }}
 * Created by {{_user_}} on {{_now_}}.
 */
@Table("{{ _tbi_.name }}")
@MessagePackMessage
public class {{_tbi_.java.name }} extends Abstract{{ _tbi_.java.name }} {

}