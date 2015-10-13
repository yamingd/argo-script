package com.{{prj._company_}}.{{prj._name_}}.service.impl.{{_module_}};

import com.argo.db.exception.EntityNotFoundException;
import com.argo.security.UserIdentity;
import com.argo.service.ServiceException;
import com.argo.collection.Pagination;

import com.{{prj._company_}}.{{prj._name_}}.mapper.{{_module_}}.{{_tbi_.java.name}}Mapper;
import com.{{prj._company_}}.{{prj._name_}}.model.{{_module_}}.{{_tbi_.java.name}};
import com.{{prj._company_}}.{{prj._name_}}.service.{{_module_}}.{{_tbi_.java.name}}Service;
import com.{{prj._company_}}.{{prj._name_}}.service.impl.ServiceBaseImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

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

{% for rc in _tbi_.refFields %}
{% if not rc.repeated %}
    @Override
    public Pagination<{{_tbi_.java.name}}> findBy{{rc.column.nameC}}(Pagination<{{_tbi_.java.name}}> resultSet, {{rc.column.java.typeName}} {{rc.column.name}}){

        return resultSet;
    }

{% endif %}
{% endfor %}

}
