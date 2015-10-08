package com.{{prj._company_}}.{{prj._name_}}.service.{{_module_}};

import com.argo.annotation.RmiService;
import com.argo.collection.Pagination;

import com.{{prj._company_}}.{{prj._name_}}.model.{{_module_}}.{{_tbi_.entityName}};
import com.{{prj._company_}}.{{prj._name_}}.service.ServiceBase;

/**
 * Created by {{_user_}} on {{_now_}}.
 */
 @RmiService
public interface {{_tbi_.entityName}}Service extends ServiceBase<{{_tbi_.entityName}}, {{_tbi_.pkType}}>  {
	
{% for rc in _tbi_.refs %}

    /**
     * 按{{rc.name}}读取
     * @param resultSet
     * @param {{rc.name}}
     * @return Pagination
     */
	Pagination<{{_tbi_.entityName}}> findBy{{rc.capName}}(Pagination<{{_tbi_.entityName}}> resultSet, {{rc.java_type}} {{rc.name}});
{% endfor %}


}