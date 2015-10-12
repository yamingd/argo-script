package com.{{prj._company_}}.{{prj._name_}}.mapper.impl.{{_module_}};

import com.argo.db.Values;
import com.argo.db.exception.EntityNotFoundException;
import com.argo.db.mysql.TableContext;
import com.argo.db.template.MySqlMapper;

import com.{{prj._company_}}.{{prj._name_}}.model.{{_module_}}.{{_tbi_.entityName}};
import com.{{prj._company_}}.{{prj._name_}}.mapper.{{_module_}}.{{_tbi_.entityName}}Mapper;
import com.{{prj._company_}}.{{prj._name_}}.mapper.{{_module_}}.{{_tbi_.entityName}}Tx;

{% for col in _refms_ %}
import com.{{prj._company_}}.{{prj._name_}}.model.{{emm[col.ref_obj.name]}}.{{col.ref_obj.entityName}};
import com.{{prj._company_}}.{{prj._name_}}.mapper.{{emm[col.ref_obj.name]}}.{{col.ref_obj.entityName}}Mapper;
{% endfor %}

import com.google.common.base.Preconditions;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;
import org.springframework.beans.factory.annotation.Autowired;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * Created by {{_user_}} on {{_now_}}.
 */
@Repository
public class {{_tbi_.entityName}}MapperImpl extends MySqlMapper<{{_tbi_.entityName}}, {{_tbi_.pkType}}> implements {{_tbi_.entityName}}Mapper {
    
    public static {{_tbi_.entityName}}Mapper instance;

    public static final String N_tableName = "{{_tbi_.name}}";
    public static final String N_pkColumnName = "{{_tbi_.pkCol.name}}";

    public static final String SQL_FIELDS = "{{_tbi_.sql_fields()}}";
    public static final List<String> columnList = new ArrayList<String>();
    public static final boolean pkAutoIncr = {{_tbi_.pkCol.pkAutoFlag()}};

    static {
{% for col in _tbi_.columns %}
        columnList.add("{{col.name}}");
{% endfor %}
    }

{% for col in _refms_ %}
    @Autowired
    protected {{col.ref_obj.entityName}}Mapper {{col.ref_obj.varName}}Mapper;    
{% endfor %}

    @Override
    public void prepare() {
        instance = this;
    }

    @Override
    public String getTableName() {
        return N_tableName;
    }

    @Override
    public String getTableName(TableContext context) {
        return null == context ? getTableName() : context.getName();
    }

    @Override
    public String getPKColumnName() {
        return N_pkColumnName;
    }

    @Override
    public String getSelectedColumns() {
        return SQL_FIELDS;
    }

    @Override
    public List<String> getColumnList() {
        return columnList;
    }

    @Override
    public Class<{{_tbi_.entityName}}> getRowClass() {
        return {{_tbi_.entityName}}.class;
    }

    @Override
    protected void setPKValue({{_tbi_.entityName}} item, KeyHolder holder) {
        item.set{{ _tbi_.pkCol.capName }}(holder.getKey().{{_tbi_.pkCol.keyHodlerFun()}});
    }

    @Override
    protected {{_tbi_.pkType}} getPkValue({{_tbi_.entityName}} item) {
        return item.get{{ _tbi_.pkCol.capName }}();
    }

    @Override
    protected boolean isPKAutoIncr() {
        return pkAutoIncr;
    }

    @Override
    public {{_tbi_.pkType}}[] toPKArrays(String pkWithCommas){
        String[] tmp = pkWithCommas.split(",");
        {{_tbi_.pkType}}[] vals = new {{_tbi_.pkType}}[tmp.length];
        for(int i=0; i<tmp.length; i++){
            vals[i] = {{_tbi_.pkType}}.valueOf(tmp[i]);
        }
        return vals;
    }

    @Override
    protected {{_tbi_.entityName}} mapRow(ResultSet rs, int rowIndex) throws SQLException {
        {{_tbi_.entityName}} item = new {{_tbi_.entityName}}();

{% for col in _tbi_.columns %}
        {{col.valTypeR}} {{col.name}}0 = Values.getResultSetValue(rs, {{col.index + 1}}, {{col.valTypeR}}.class);
{% if col.valTypeR != col.java_type %}        
        {{col.java_type}} {{col.name}} = Values.get({{col.name}}0, {{col.java_type}}.class);
        item.set{{col.capName}}({{col.name}});
{% else %}
        item.set{{col.capName}}({{col.name}}0);
{% endif %}

{% endfor %}        
        return item;
    }

    @Override
    protected void setInsertStatementValues(PreparedStatement ps, {{_tbi_.entityName}} item) throws SQLException {

{% set index = -1 %}
{% for col in _tbi_.insertColumns() %}
{% set index = index + 1 %}
{% if col.valTypeR != col.java_type %} 
        {{col.java_type}} {{col.name}}0 = item.get{{col.capName}}();
        {{col.valTypeR}} {{col.name}} = Values.get({{col.name}}0, {{col.valTypeR}}.class);
        ps.{{col.sqlSetter}}({{index + 1}}, {{col.sqlValueSetter}});
{% else %}
        {{col.java_type}} {{col.name}} = item.get{{col.capName}}();
        ps.{{col.sqlSetter}}({{index + 1}}, {{col.sqlValueSetter}}); 
{% endif %}

{% endfor %} 
    }

    @Override
    public List<{{_tbi_.entityName}}> selectRows(TableContext context, final List<{{_tbi_.pkType}}> args, final boolean ascending) throws DataAccessException{
        Preconditions.checkNotNull(args);
        return super.selectRows(context, args.toArray(new {{_tbi_.pkType}}[0]), ascending);
    }

    @Override
    @{{_tbi_.entityName}}Tx
    public boolean insert(TableContext context, {{_tbi_.entityName}} item) throws DataAccessException {
        return super.insert(context, item);
    }

    @Override
    @{{_tbi_.entityName}}Tx
    public boolean insertBatch(TableContext context, List<{{_tbi_.entityName}}> list) throws DataAccessException {
        return super.insertBatch(context, list);
    }

    @Override
    @{{_tbi_.entityName}}Tx
    public boolean update(TableContext context, {{_tbi_.entityName}} item) throws DataAccessException {
        Preconditions.checkNotNull(item);

        final StringBuilder s = new StringBuilder(128);
        s.append(UPDATE).append(getTableName(context)).append(SET);

        final List<Object> args = new ArrayList<Object>();

{% for col in _tbi_.columns %}
{% if not col.key %}
        if (null != item.get{{col.capName}}()){
            s.append("{{col.name}}=?, ");
{% if col.valTypeR != col.java_type %}        
            {{col.valTypeR}} {{col.name}} = Values.get(item.get{{col.capName}}(), {{col.valTypeR}}.class);
            args.add({{col.name}});
{% else %}
            args.add(item.get{{col.capName}}());
{% endif %}
        }
{% endif %}
{% endfor %} 

        if (args.size() == 0){
            logger.warn("Nothing to update. ");
            return false;
        }

        s.setLength(s.length() - 2);
        s.append(WHERE).append(N_pkColumnName).append(S_E_Q);
        args.add(getPkValue(item));

        boolean ret = super.update(s.toString(), args);

        super.afterUpdate(context, item);

        return false;
    }

    @Override
    @{{_tbi_.entityName}}Tx
    public boolean update(String sql, List<Object> args) {
        return super.update(sql, args);
    }

    @Override
    @{{_tbi_.entityName}}Tx
    public boolean update(TableContext context, String values, String where, Object... args) throws DataAccessException {
        return super.update(context, values, where, args);
    }

    @Override
    @{{_tbi_.entityName}}Tx
    public boolean delete(TableContext context, {{_tbi_.entityName}} item) throws DataAccessException {
        return super.delete(context, item);
    }

    @Override
    @{{_tbi_.entityName}}Tx
    public boolean deleteBy(TableContext context, {{_tbi_.pkType}} id) throws DataAccessException {
        return super.deleteBy(context, id);
    }

    @Override
    @{{_tbi_.entityName}}Tx
    public boolean deleteBy(TableContext context, String where, Object... args) throws DataAccessException {
        return super.deleteBy(context, where, args);
    }

{% for rc in _tbi_.refs %}
    @Override
    public void wrap{{rc.ref_varNameC}}(TableContext context, {{_tbi_.entityName}} item) throws DataAccessException, EntityNotFoundException{
        Preconditions.checkNotNull(item);
{% if rc.pbrepeated %}
        List<{{rc.ref_obj.entityName}}> refItem = {{rc.refJavaMapper(_tbi_.varName)}}.findRows(context, item.get{{rc.capName}}(), false);
        item.set{{rc.ref_varNameC}}(refItem);
{% else %}
        {{rc.ref_obj.entityName}} refItem = {{rc.refJavaMapper(_tbi_.varName)}}.find(context, item.get{{rc.capName}}());
        item.set{{rc.ref_varNameC}}(refItem);
{% endif %}
    }

    @Override
    public void wrap{{rc.ref_varNameC}}(TableContext context, List<{{_tbi_.entityName}}> list) throws DataAccessException{
        Preconditions.checkNotNull(list);
{% if rc.pbrepeated %}
        for(int i=0; i<list.size(); i++){
            {{_tbi_.entityName}} item = list.get(i);
            List<{{rc.ref_obj.entityName}}> refItems = {{rc.refJavaMapper(_tbi_.varName)}}.findRows(context, item.get{{rc.capName}}(), false);
            item.set{{rc.ref_varNameC}}(refItems);
        }
{% else %}
        List<{{rc.java_type}}> ids = new ArrayList<{{rc.java_type}}>();
        for(int i=0; i<list.size(); i++){
            {{rc.java_type}} v0 = list.get(i).get{{rc.capName}}();
            if(ids.contains(v0)){
                continue;
            }
            ids.add(v0);
        }
        List<{{rc.ref_obj.entityName}}> refItems = {{rc.refJavaMapper(_tbi_.varName)}}.selectRows(context, ids, false);
        for(int i=0; i<refItems.size(); i++){
            {{rc.java_type}} v0 = refItems.get(i).getId();
            for(int j=0; j<list.size(); j++){
                {{rc.java_type}} v1 = list.get(j).get{{rc.capName}}();
                if(v0.equals(v1)){
                     list.get(j).set{{rc.ref_varNameC}}(refItems.get(i));
                }
            }
        }
{% endif %}
    }
{% endfor %}
    /********分隔线*******/


}
