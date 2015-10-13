package com.{{prj._company_}}.{{prj._name_}}.service.{{_module_}};

import com.argo.annotation.RmiService;
import com.argo.collection.Pagination;

import com.{{prj._company_}}.{{prj._name_}}.model.{{_module_}}.{{_tbi_.java.name}};
import com.{{prj._company_}}.{{prj._name_}}.service.ServiceBase;

/**
 * Created by {{_user_}} on {{_now_}}.
 */
@RmiService
public interface {{_tbi_.java.name}}Service extends ServiceBase<{{_tbi_.java.name}}, {{_tbi_.pk.java.typeName}}>  {
	
{% for rc in _tbi_.refFields %}
{% if not rc.repeated %}
    /**
     * 按{{rc.name}}读取
     * @param resultSet
     * @param {{rc.column.name}}
     * @return Pagination
     */
	Pagination<{{_tbi_.java.name}}> findBy{{rc.column.nameC}}(Pagination<{{_tbi_.java.name}}> resultSet, {{rc.column.java.typeName}} {{rc.column.name}});

{% endif %}
{% endfor %}


}