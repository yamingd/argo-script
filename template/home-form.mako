package com.{{prj._company_}}.{{prj._project_}}.web.home.{{_module_}};

import com.{{prj._company_}}.{{prj._project_}}.model.{{_module_}}.{{_tbi_.java.name}};
import org.hibernate.validator.constraints.Length;
import org.hibernate.validator.constraints.NotEmpty;
import javax.validation.constraints.NotNull;
import org.springframework.context.annotation.Scope;
import com.argo.annotation.ApiParameterDoc;

@Scope("prototype")
public class Home{{_tbi_.java.name}}Form {
    
{% for col in _cols_ %}
    /**
     * {{col.docComment}}
     * {{col.typeName}}
     */
    {{ col.annotationMark() }}private {{col.java.typeName}} {{col.name}};
{% endfor %}

{% for col in _cols_ %}
    /**
     * {{col.docComment}}
     */
    public {{col.java.typeName}} get{{ col.java.getterName }}(){
        return this.{{ col.name }};
    }
    public void set{{col.java.setterName}}({{col.java.typeName}} {{col.name}}){
        this.{{col.name}} = {{col.name}};
    }
{% endfor %}

    public {{_tbi_.java.name}} to(){
        {{_tbi_.java.name}} item = new {{_tbi_.java.name}}();
{% for col in _cols_ %}
        item.set{{col.java.setterName}}(this.get{{col.java.getterName}}());
{% endfor %}
        return item;
    }
}