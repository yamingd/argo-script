package {{ _tbi_.java.model_ns }};

import com.argo.annotation.Column;
import com.google.common.base.MoreObjects;
{% for r in _tbi_.impJavas %}
import {{r.model_ns}}.{{r.name}};
{% endfor %}

import java.util.Date;
import java.util.List;
import java.io.Serializable;
import javax.annotation.Generated;
{% if _tbi_.hasBigDecimal %}
import java.math.BigDecimal;
{% endif %}



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
    {{col.columnMark}} protected {{col.java.typeName}} {{col.java.name}};
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
    protected {{ref.java.typeName}} {{ref.java.name}};
    public {{ref.java.typeName}} get{{ ref.java.getterName }}(){
        return this.{{ ref.java.name }};
    }
    public void set{{ ref.java.setterName }}({{ ref.java.typeName }} {{ ref.java.name }}){
        this.{{ ref.java.name }} = {{ ref.java.name }};
    }

{% endfor %}    

    @Override
    public String toString() {
        return MoreObjects.toStringHelper(this)
{% for col in _tbi_.columns %}
                .add("{{ col.java.name }}", {{ col.java.name }})
{% endfor %}
                .toString();
    }

}