package com.{{prj._company_}}.{{prj._name_}}.service.impl.{{_module_}};

import com.argo.db.exception.EntityNotFoundException;
import com.argo.security.UserIdentity;
import com.argo.service.ServiceException;
import com.argo.collection.Pagination;

import com.{{prj._company_}}.{{prj._name_}}.mapper.{{_module_}}.{{_tbi_.entityName}}Mapper;
import com.{{prj._company_}}.{{prj._name_}}.model.{{_module_}}.{{_tbi_.entityName}};
import com.{{prj._company_}}.{{prj._name_}}.service.{{_module_}}.{{_tbi_.entityName}}Service;
import com.{{prj._company_}}.{{prj._name_}}.service.impl.ServiceBaseImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * Created by {{_user_}} on {{_now_}}.
 */
@Service
public class {{_tbi_.entityName}}ServiceImpl extends ServiceBaseImpl implements {{_tbi_.entityName}}Service {

    @Autowired
    protected {{_tbi_.entityName}}Mapper {{_tbi_.varName}}Mapper;

    @Override
    public {{_tbi_.entityName}} find(UserIdentity user, {{_tbi_.pkType}} id) throws EntityNotFoundException {
        return {{_tbi_.varName}}Mapper.find(null, id);
    }

    @Override
    public List<{{_tbi_.entityName}}> findList(UserIdentity user, {{_tbi_.pkType}}... ids) {
        return {{_tbi_.varName}}Mapper.selectRows(null, ids, true);
    }

    @Override
    public {{_tbi_.entityName}} create(UserIdentity user, {{_tbi_.entityName}} item) throws ServiceException {
        {{_tbi_.varName}}Mapper.insert(null, item);
        return item;
    }

    @Override
    public {{_tbi_.entityName}} save(UserIdentity user, {{_tbi_.entityName}} item) throws ServiceException {
        {{_tbi_.varName}}Mapper.update(null, item);
        return item;
    }

    @Override
    public boolean removeBy(UserIdentity user, {{_tbi_.pkType}} id) throws ServiceException {
        return {{_tbi_.varName}}Mapper.deleteBy(null, id);
    }

    @Override
    public boolean remove(UserIdentity user, {{_tbi_.entityName}} item) throws ServiceException {
        return {{_tbi_.varName}}Mapper.delete(null, item);
    }

{% for rc in _tbi_.refs %}
    @Override
    public Pagination<{{_tbi_.entityName}}> findBy{{rc.capName}}(Pagination<{{_tbi_.entityName}}> resultSet, {{rc.java_type}} {{rc.name}}){

        return resultSet;
    }
    
{% endfor %}
}
