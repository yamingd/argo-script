package com.{{prj._company_}}.{{prj._name_}}.service.impl.{{_module_}};

import com.argo.collection.Pagination;
import com.argo.db.exception.EntityNotFoundException;
import com.argo.security.UserIdentity;
import com.argo.service.ServiceException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Service;

import java.util.Collections;
import java.util.List;

import com.{{prj._company_}}.{{prj._name_}}.mapper.{{_module_}}.{{_tbi_.java.name}}Mapper;
import com.{{prj._company_}}.{{prj._name_}}.model.{{_module_}}.{{_tbi_.java.name}};
import com.{{prj._company_}}.{{prj._name_}}.service.{{_module_}}.{{_tbi_.java.name}}Service;
import com.{{prj._company_}}.{{prj._name_}}.service.impl.ServiceBaseImpl;

/**
 * Created by {{_user_}} on {{_now_}}.
 */
@Service
public class {{_tbi_.java.name}}ServiceImpl extends ServiceBaseImpl implements {{_tbi_.java.name}}Service {

    @Autowired
    protected {{_tbi_.java.name}}Mapper {{_tbi_.java.varName}}Mapper;

    @Override
    public {{_tbi_.java.name}} find(UserIdentity user, {{_tbi_.pk.java.typeName}} id) throws EntityNotFoundException {
        return {{_tbi_.java.varName}}Mapper.find(null, id);
    }

    @Override
    public List<{{_tbi_.java.name}}> findList(UserIdentity user, {{_tbi_.pk.java.typeName}}... ids) {
        return {{_tbi_.java.varName}}Mapper.selectRows(null, ids, true);
    }

    @Override
    public {{_tbi_.java.name}} create(UserIdentity user, {{_tbi_.java.name}} item) throws ServiceException {
        {{_tbi_.java.varName}}Mapper.insert(null, item);
        return item;
    }

    @Override
    public {{_tbi_.java.name}} save(UserIdentity user, {{_tbi_.java.name}} item) throws ServiceException {
        {{_tbi_.java.varName}}Mapper.update(null, item);
        return item;
    }

    @Override
    public boolean removeBy(UserIdentity user, {{_tbi_.pk.java.typeName}} id) throws ServiceException {
        return {{_tbi_.java.varName}}Mapper.deleteBy(null, id);
    }

    @Override
    public boolean remove(UserIdentity user, {{_tbi_.java.name}} item) throws ServiceException {
        return {{_tbi_.java.varName}}Mapper.delete(null, item);
    }

{% for qf in _tbi_.funcs %}
{% if qf.unique %}
    @Override
    public {{_tbi_.java.name}} findBy{{ qf.name }}(UserIdentity user, {{ qf.arglist }}) throws ServiceException {
        Object[] params = new Object[]{ {{ qf.varlist }} };
        List<{{_tbi_.pk.java.typeName}}> ids = null;
        try {
            ids = {{_tbi_.java.varName}}Mapper.selectPks(null, "{{ qf.sql_where }}", "{{_tbi_.pk.name}} desc", 1, params);
        } catch (DataAccessException e) {
            throw new ServiceException(e, 60500); // 业务错误代号
        }
        if (ids.size() == 0){
            return null;
        }
        List<{{_tbi_.java.name}}> list = {{_tbi_.java.varName}}Mapper.selectRows(null, ids, false);
        return list.get(0);
    }
{% else %}
    @Override
    public Pagination<{{_tbi_.java.name}}> findBy{{ qf.name }}(UserIdentity user, Pagination<{{_tbi_.java.name}}> resultSet, {{ qf.arglist }}) throws ServiceException {
        Object[] params = new Object[]{ {{ qf.varlist }}, resultSet.getStart()};
        List<{{_tbi_.pk.java.typeName}}> ids = null;
        try {
            if (1 == resultSet.getIndex()){
                if (0 == resultSet.getStart()){
                    ids = {{_tbi_.java.varName}}Mapper.selectPks(null, "{{ qf.sql_where }} and {{_tbi_.pk.name}} > ?", "{{_tbi_.pk.name}} desc", resultSet.getSize(), params);
                }else {
                    ids = {{_tbi_.java.varName}}Mapper.selectPks(null, "{{ qf.sql_where }} and {{_tbi_.pk.name}} > ?", "{{_tbi_.pk.name}} asc", resultSet.getSize(), params);
                    Collections.reverse(ids);
                }
            }else {
                ids = {{_tbi_.java.varName}}Mapper.selectPks(null, "{{ qf.sql_where }} and {{_tbi_.pk.name}} < ?", "{{_tbi_.pk.name}} desc", resultSet.getSize(), params);
            }
            List<{{_tbi_.java.name}}> list = {{_tbi_.java.varName}}Mapper.selectRows(null, ids, false);
            resultSet.setItems(list);
        } catch (DataAccessException e) {
            throw new ServiceException(e, 60500); // 业务错误代号
        }
        return resultSet;
    }
{% endif %}

{% endfor %}

}
