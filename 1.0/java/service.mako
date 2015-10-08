package com.{{_company_}}.{{_project_}}.{{_module_}}.service;

import com.argo.core.entity.Pagination;
import com.argo.core.exception.EntityNotFoundException;
import com.argo.db.template.ServiceBase;
import com.{{_company_}}.{{_project_}}.{{_module_}}.{{_tbi_.entityName}};

import java.util.Map;
import java.util.List;

/**
 * Created by $User on {{now.strftime('%Y-%m-%d %H:%M')}}.
 */
public interface {{_tbi_.entityName}}Service extends ServiceBase  {
	
	Pagination<{{_tbi_.entityName}}> findAll(Pagination page);

}