package com.{{prj._company_}}.{{prj._name_}}.model.{{_module_}};

import com.argo.annotation.Column;
import com.argo.annotation.Table;
import com.google.common.base.Objects;
import org.msgpack.annotation.MessagePackMessage;
import java.util.Date;
import java.util.List;
import java.io.Serializable;
import javax.annotation.Generated;

{% for col in _refms_ %}
import com.{{prj._company_}}.{{prj._name_}}.model.{{emm[col.ref_obj.name]}}.{{col.ref_obj.entityName}};
{% endfor %}

/**
 * {{ _tbi_.hint }}
 * Created by {{_user_}} on {{_now_}}.
 */
@Generated("Generate from mysql table")
public abstract class Abstract{{_tbi_.entityName}} implements Serializable {
    
{% for col in _cols_ %}
    /**
     * {{col.comment}}
     * {{col.typeName}} {{col.defaultTips}}
     */
    {{col.columnMark}}private {{col.java_type}} {{col.name}};
{% endfor %}

{% for col in _cols_ %}
    /**
     * {{col.comment}}
     * {{col.defaultTips}}
     */
    public {{col.java_type}} get{{ col.capName }}(){
        return this.{{ col.name }};
    }
    public void set{{col.capName}}({{col.java_type}} {{col.name}}){
        this.{{col.name}} = {{col.name}};
    }
{% endfor %}

    /****引用实体****/
{% for col in _tbi_.refs %}

    private {{col.ref_javatype}} {{col.ref_varName}};
    public {{col.ref_javatype}} get{{ col.ref_varName.capitalize() }}(){
        return this.{{ col.ref_varName }};
    }
    public void set{{col.ref_varNameC}}({{col.ref_javatype}} {{col.ref_varName}}){
        this.{{col.ref_varName}} = {{col.ref_varName}};
    }

{% endfor %}    

}