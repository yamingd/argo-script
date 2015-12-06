package com.{{prj._company_}}.{{prj._name_}}.mapper.{{_module_}};

import com.argo.db.SqlMapper;
import com.argo.db.exception.EntityNotFoundException;
import com.argo.db.mysql.TableContext;
import org.springframework.dao.DataAccessException;

import java.util.List;

import com.{{prj._company_}}.{{prj._name_}}.model.{{_module_}}.{{_tbi_.java.name}};

/**
 * Created by {{_user_}}.
 */
public interface {{_tbi_.java.name}}Mapper extends SqlMapper<{{_tbi_.java.name}}, {{_tbi_.pk.java.typeName}}> {

{% for rc in _tbi_.refFields %}
	/**
     * 关联 {{rc.java.nameC}}
     * @param context
     * @param item
     * @throws DataAccessException
     * @throws EntityNotFoundException
     */    
    void wrap{{rc.java.nameC}}(TableContext context, {{_tbi_.java.name}} item) throws DataAccessException, EntityNotFoundException;

    /**
     * 关联 {{rc.java.nameC}}
     * @param context
     * @param list
     * @throws DataAccessException
     */
    void wrap{{rc.java.nameC}}(TableContext context, List<{{_tbi_.java.name}}> list) throws DataAccessException;
    
{% endfor %}

}