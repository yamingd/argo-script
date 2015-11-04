package com.{{prj._company_}}.{{prj._name_}}.mapper.impl.{{_module_}};

import com.argo.db.Values;
import com.argo.db.exception.EntityNotFoundException;
import com.argo.db.mysql.TableContext;
import com.argo.db.template.MySqlMapper;

import com.{{prj._company_}}.{{prj._name_}}.model.{{_module_}}.{{_tbi_.java.name}};
import com.{{prj._company_}}.{{prj._name_}}.mapper.{{_module_}}.{{_tbi_.java.name}}Mapper;
import com.{{prj._company_}}.{{prj._name_}}.mapper.{{_module_}}.{{_tbi_.java.name}}Tx;

{% for r in _tbi_.impJavas %}
import com.{{prj._company_}}.{{prj._name_}}.model.{{ r.package }}.{{ r.name }};
import com.{{prj._company_}}.{{prj._name_}}.mapper.{{ r.package }}.{{ r.name }}Mapper;
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
public class {{_tbi_.java.name}}MapperImpl extends MySqlMapper<{{_tbi_.java.name}}, {{_tbi_.pk.java.typeName}}> implements {{_tbi_.java.name}}Mapper {
    
    public static {{_tbi_.java.name}}Mapper instance;

    public static final String N_tableName = "{{_tbi_.name}}";
    public static final String N_pkColumnName = "{{_tbi_.pk.name}}";

    public static final String SQL_FIELDS = "{{_tbi_.java.dbFields()}}";
    public static final List<String> columnList = new ArrayList<String>();
    public static final boolean pkAutoIncr = {{_tbi_.pk.java.autoIncrementMark()}};

    static {
{% for col in _tbi_.columns %}
        columnList.add("{{col.name}}");
{% endfor %}
    }

{% for r in _tbi_.impJavas %}
    @Autowired
    protected {{r.name}}Mapper {{ r.varName }}Mapper;    
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
    public Class<{{_tbi_.java.name}}> getRowClass() {
        return {{_tbi_.java.name}}.class;
    }

    @Override
    protected void setPKValue({{_tbi_.java.name}} item, KeyHolder holder) {
        item.set{{ _tbi_.pk.java.setterName }}(holder.getKey().{{_tbi_.pk.java.keyHodlerFun()}});
    }

    @Override
    protected {{_tbi_.pk.java.typeName}} getPkValue({{_tbi_.java.name}} item) {
        return item.get{{ _tbi_.pk.java.getterName }}();
    }

    @Override
    protected boolean isPKAutoIncr() {
        return pkAutoIncr;
    }

    @Override
    public {{_tbi_.pk.java.typeName}}[] toPKArrays(String pkWithCommas){
        String[] tmp = pkWithCommas.split(",");
        {{_tbi_.pk.java.typeName}}[] vals = new {{_tbi_.pk.java.typeName}}[tmp.length];
        for(int i=0; i<tmp.length; i++){
            vals[i] = {{_tbi_.pk.java.typeName}}.valueOf(tmp[i]);
        }
        return vals;
    }

    @Override
    protected {{_tbi_.java.name}} mapRow(ResultSet rs, int rowIndex) throws SQLException {
        {{_tbi_.java.name}} item = new {{_tbi_.java.name}}();

{% for col in _tbi_.columns %}
{% if col.java.typeDiff %}    
        {{col.java.valType}} {{col.java.name}}0 = Values.getResultSetValue(rs, {{col.index + 1}}, {{col.java.valType}}.class);    
        {{col.java.typeName}} {{col.java.name}} = Values.get({{col.java.name}}0, {{col.java.typeName}}.class);
        item.set{{col.java.setterName}}({{col.java.name}});
{% else %}
        {{col.java.typeName}} {{col.java.name}}0 = Values.getResultSetValue(rs, {{col.index + 1}}, {{col.java.typeName}}.class);
        item.set{{col.java.setterName}}({{col.java.name}}0);
{% endif %}

{% endfor %}        
        return item;
    }

    @Override
    protected void setInsertStatementValues(PreparedStatement ps, {{_tbi_.java.name}} item) throws SQLException {

{% set index = -1 %}
{% for col in _tbi_.columns %}
{% if not col.auto_increment %}
{% set index = index + 1 %}
{% if col.java.typeDiff %} 
        {{col.java.typeName}} {{col.java.name}}0 = item.get{{col.java.getterName}}();
        {{col.java.valType}} {{col.java.name}} = Values.get({{col.java.name}}0, {{col.java.valType}}.class);
        ps.{{col.java.jdbcSetter}}({{index + 1}}, {{col.java.jdbcValueFunc}});
{% else %}
        {{col.java.typeName}} {{col.java.name}} = item.get{{col.java.getterName}}();
        ps.{{col.java.jdbcSetter}}({{index + 1}}, {{col.java.jdbcValueFunc}}); 
{% endif %}
{% endif %}

{% endfor %} 
    }

    @Override
    public List<{{_tbi_.java.name}}> selectRows(TableContext context, final List<{{_tbi_.pk.java.typeName}}> args, final boolean ascending) throws DataAccessException{
        Preconditions.checkNotNull(args);
        return super.selectRows(context, args.toArray(new {{_tbi_.pk.java.typeName}}[0]), ascending);
    }

    @Override
    @{{_tbi_.java.name}}Tx
    public boolean insert(TableContext context, {{_tbi_.java.name}} item) throws DataAccessException {
        return super.insert(context, item);
    }

    @Override
    @{{_tbi_.java.name}}Tx
    public boolean insertBatch(TableContext context, List<{{_tbi_.java.name}}> list) throws DataAccessException {
        return super.insertBatch(context, list);
    }

    @Override
    @{{_tbi_.java.name}}Tx
    public boolean update(TableContext context, {{_tbi_.java.name}} item) throws DataAccessException {
        Preconditions.checkNotNull(item);

        final StringBuilder s = new StringBuilder(128);
        s.append(UPDATE).append(getTableName(context)).append(SET);

        final List<Object> args = new ArrayList<Object>();

{% for col in _tbi_.columns %}
{% if not col.key %}
        if (null != item.get{{col.java.getterName}}()){
            s.append("{{col.name}}=?, ");
{% if col.java.typeDiff %}        
            {{col.java.valType}} {{col.java.name}} = Values.get(item.get{{col.java.getterName}}(), {{col.java.valType}}.class);
            args.add({{col.java.name}});
{% else %}
            args.add(item.get{{col.java.getterName}}());
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
    @{{_tbi_.java.name}}Tx
    public boolean update(String sql, List<Object> args) {
        return super.update(sql, args);
    }

    @Override
    @{{_tbi_.java.name}}Tx
    public boolean update(TableContext context, String values, String where, Object... args) throws DataAccessException {
        return super.update(context, values, where, args);
    }

    @Override
    @{{_tbi_.java.name}}Tx
    public boolean delete(TableContext context, {{_tbi_.java.name}} item) throws DataAccessException {
        return super.delete(context, item);
    }

    @Override
    @{{_tbi_.java.name}}Tx
    public boolean deleteBy(TableContext context, {{_tbi_.pk.java.typeName}} id) throws DataAccessException {
        return super.deleteBy(context, id);
    }

    @Override
    @{{_tbi_.java.name}}Tx
    public boolean deleteBy(TableContext context, String where, Object... args) throws DataAccessException {
        return super.deleteBy(context, where, args);
    }

{% for rc in _tbi_.refFields %}
    @Override
    public void wrap{{rc.java.nameC}}(TableContext context, {{_tbi_.java.name}} item) throws DataAccessException, EntityNotFoundException{
        Preconditions.checkNotNull(item);
{% if rc.java.repeated %}
        {{rc.java.typeName}} refItem = {{rc.java.mapper(_tbi_.java)}}.findRows(context, item.get{{rc.column.java.getterName}}(), false);
        item.set{{rc.java.setterName}}(refItem);
{% else %}
        {{rc.java.typeName}} refItem = {{rc.java.mapper(_tbi_.java)}}.find(context, item.get{{rc.column.java.getterName}}());
        item.set{{rc.java.setterName}}(refItem);
{% endif %}
    }

    @Override
    public void wrap{{rc.java.nameC}}(TableContext context, List<{{_tbi_.java.name}}> list) throws DataAccessException{
        Preconditions.checkNotNull(list);
{% if rc.repeated %}
        for(int i=0; i<list.size(); i++){
            {{_tbi_.java.name}} item = list.get(i);
            {{rc.java.typeName}} refItems = {{rc.java.mapper(_tbi_.java)}}.findRows(context, item.get{{rc.column.java.getterName}}(), false);
            item.set{{rc.java.setterName}}(refItems);
        }
{% else %}
        List<{{rc.column.java.typeName}}> ids = new ArrayList<{{rc.column.java.typeName}}>();
        for(int i=0; i<list.size(); i++){
            {{rc.column.java.typeName}} v0 = list.get(i).get{{rc.column.java.getterName}}();
            if(null == v0){
                continue;
            }
            if(ids.contains(v0)){
                continue;
            }
            ids.add(v0);
        }
        List<{{rc.java.typeName}}> refItems = {{rc.java.mapper(_tbi_.java)}}.selectRows(context, ids, false);
        for(int i=0; i<refItems.size(); i++){
            {{rc.table.pk.java.typeName}} v0 = refItems.get(i).get{{rc.table.pk.java.getterName}}();
            for(int j=0; j<list.size(); j++){
                {{rc.column.java.typeName}} v1 = list.get(j).get{{rc.column.java.getterName}}();
                if(null != v1 && v0.equals(v1)){
                    list.get(j).set{{rc.java.setterName}}(refItems.get(i));
                }
            }
        }
{% endif %}
    }
{% endfor %}
    /********分隔线*******/


}
