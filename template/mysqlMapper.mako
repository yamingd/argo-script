package com.{{prj._company_}}.{{prj._name_}}.mapper.{{_module_}};

import com.argo.db.SqlMapper;
import com.argo.db.exception.EntityNotFoundException;
import com.argo.db.mysql.TableContext;
import org.springframework.dao.DataAccessException;

import java.util.List;

import com.{{prj._company_}}.{{prj._name_}}.model.{{_module_}}.{{_tbi_.entityName}};

/**
 * Created by {{_user_}} on {{_now_}}.
 */
public interface {{_tbi_.entityName}}Mapper extends SqlMapper<{{_tbi_.entityName}}, {{_tbi_.pkType}}> {

{% for rc in _tbi_.refs %}
	/**
     * 关联 {{rc.ref_varNameC}}
     * @param context
     * @param item
     * @throws DataAccessException
     * @throws EntityNotFoundException
     */    
    void wrap{{rc.ref_varNameC}}(TableContext context, {{_tbi_.entityName}} item) throws DataAccessException, EntityNotFoundException;

    /**
     * 关联 {{rc.ref_varNameC}}
     * @param context
     * @param list
     * @throws DataAccessException
     */
    void wrap{{rc.ref_varNameC}}(TableContext context, List<{{_tbi_.entityName}}> list) throws DataAccessException;
    
{% endfor %}

}