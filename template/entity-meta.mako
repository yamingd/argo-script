package com.{{prj._company_}}.{{prj._name_}}.model.{{_module_}};

import com.argo.annotation.Column;
import com.argo.annotation.Table;
import com.google.common.base.Objects;
import com.google.gson.annotations.Expose;
import org.msgpack.annotation.MessagePackMessage;
import java.util.Date;
import java.util.List;
import java.io.Serializable;
import javax.annotation.Generated;

{% for r in _tbi_.impJavas %}
import com.{{prj._company_}}.{{prj._name_}}.model.{{r.package}}.{{r.name}};
{% endfor %}

/**
 * {{ _tbi_.hint }}
 * Created by {{_user_}}.
 */
@Generated("Generate from mysql table")
public abstract class Abstract{{_tbi_.java.name}} implements Serializable {
    
{% for col in _tbi_.columns %}
    /**
     * {{col.docComment}}
     * {{col.typeName}} {{col.defaultTips}}
     */
    {{col.columnMark}} @Expose private {{col.java.typeName}} {{col.java.name}};
{% endfor %}

{% for col in _tbi_.columns %}
    /**
     * {{col.docComment}}
     * {{col.defaultTips}}
     */
    public {{col.java.typeName}} get{{ col.java.getterName }}(){
        return this.{{ col.java.name }};
    }
    public void set{{col.java.setterName}}({{col.java.typeName}} {{col.java.name}}){
        this.{{col.java.name}} = {{col.java.name}};
    }
{% endfor %}

    /****引用实体****/
{% for ref in _tbi_.refFields %}
    /**
     *
     * {{ref.docComment}}
     */
    private {{ref.java.typeName}} {{ref.java.name}};
    public {{ref.java.typeName}} get{{ ref.java.getterName }}(){
        return this.{{ ref.java.name }};
    }
    public void set{{ ref.java.setterName }}({{ ref.java.typeName }} {{ ref.java.name }}){
        this.{{ ref.java.name }} = {{ ref.java.name }};
    }

{% endfor %}    

}