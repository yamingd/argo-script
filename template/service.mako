package com.{{prj._company_}}.{{prj._name_}}.service.{{_module_}};

import com.argo.annotation.RmiService;
import com.argo.collection.Pagination;
import com.argo.security.UserIdentity;
import com.argo.service.ServiceException;

import com.{{prj._company_}}.{{prj._name_}}.model.{{_module_}}.{{_tbi_.java.name}};
import com.{{prj._company_}}.{{prj._name_}}.service.ServiceBase;

/**
 * Created by {{_user_}} on {{_now_}}.
 */
@RmiService
public interface {{_tbi_.java.name}}Service extends ServiceBase<{{_tbi_.java.name}}, {{_tbi_.pk.java.typeName}}>  {

{% for qf in _tbi_.funcs %}
{% if qf.unique %}
	/**
     * 按{{ qf.nameWithDot }}读取
{% for c in qf.cols %}
     * @param {{c.name}}
{% endfor %}
     * @return {{_tbi_.java.name}}
     */
	{{_tbi_.java.name}} findBy{{ qf.name }}(UserIdentity user, {{ qf.arglist }}) throws ServiceException;
{% else %}
    /**
     * 按{{ qf.nameWithDot }}分页读取
     * resultSet需要设置size, index, start 三个属性
     * @param resultSet
{% for c in qf.cols %}
     * @param {{c.name}}
{% endfor %}
     * @return Pagination
     */
    Pagination<{{_tbi_.java.name}}> findBy{{ qf.name }}(UserIdentity user, Pagination<{{_tbi_.java.name}}> resultSet, {{ qf.arglist }}) throws ServiceException;
{% endif %}

{% endfor %}

}