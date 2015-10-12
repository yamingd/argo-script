package com.{{prj._company_}}.{{prj._project_}}.mapper.{{_module_}};

import android.support.v4.util.ArrayMap;
import com.argo.sqlite.SqliteMapper;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import net.sqlcipher.Cursor;
import net.sqlcipher.database.SQLiteStatement;
import timber.log.Timber;

import com.{{prj._company_}}.{{prj._project_}}.protobuf.{{_module_}}.PB{{_tbi_.entityName}};

{% for c in _refms_ %}
import com.{{prj._company_}}.{{prj._project_}}.protobuf.{{c.ref_obj.mname}}.PB{{c.ref_obj.entityName}};
import com.{{prj._company_}}.{{prj._project_}}.mapper.{{c.ref_obj.mname}}.PB{{c.ref_obj.entityName}}Mapper; 
{% endfor %}


public class PB{{_tbi_.entityName}}Mapper extends SqliteMapper<PB{{_tbi_.entityName}}, {{_tbi_.pkType}}> {

  private static String pkColumn;

  private static String tableName;

  public static String dbContextTag;

  public static PB{{_tbi_.entityName}}Mapper instance;

  static {
    pkColumn = "{{_tbi_.pkCol.name}}";
    tableName = "{{_tbi_.name}}";
    dbContextTag = "default"; //chang this if having different sqlite db
  }

  public PB{{_tbi_.entityName}}Mapper() {
    super();
    instance = this;
  }

  @Override
  protected void bindInsertStatement(SQLiteStatement statement, PB{{_tbi_.entityName}} o) {
{% for c in _tbi_.columns %}
    statement.{{c.sqlite3.binder}}({{c.index + 1}}, {{c.sqlite3.bindValue('o')}});
{% endfor %}

  }

  @Override
  public List<String> getColumns() {
    List<String> columns = new ArrayList<String>();
{% for c in _tbi_.columns %}
    columns.add("{{c.name}}");
{% endfor %}
    return columns;
  }

  @Override
  public Map<String, String> getColumnInfo() {
    Map<String, String> columns = new ArrayMap<String, String>();
{% for c in _tbi_.columns %}
    columns.put("{{c.name}}", "{{c.sqlite3.typeName}}");
{% endfor %}
    return columns;
  }

  @Override
  public String getPkColumn() {
    return pkColumn;
  }

  @Override
  public String getTableName() {
    return tableName;
  }

  @Override
  public Class<PB{{_tbi_.entityName}}> getClassType() {
    return PB{{_tbi_.entityName}}.class;
  }

  @Override
  public String getDbContextTag() {
    return dbContextTag;
  }

  @Override
  public String getTableCreateSql() {
    String sql = "{{_tbi_.sqlite3.createTableSql}}";
    return sql;
  }

  @Override
  public void prepare() {
    super.prepare();
    this.dbContext.initTable(this);
  }

  @Override
  public boolean saveWithRef(PB{{_tbi_.entityName}} o) {
    boolean ret = super.saveWithRef(o);
    if (!ret) {
      return false;
    }
{% for c in _tbi_.refs %}
    // save {{c.ref_varNameC}};
{% if c.pbrepeated %}
    List<PB{{c.ref_obj.entityName}}> refVar{{c.index}} = o.get{{c.ref_varNameC}}List();
    if (null != refVar{{c.index}}) {
      PB{{c.ref_obj.entityName}}Mapper.instance.saveWithRef(refVar{{c.index}});
    }
{% else %}
    PB{{c.ref_obj.entityName}} refVar{{c.index}} = o.get{{c.ref_varNameC}}();
    if (null != refVar{{c.index}}) {
      PB{{c.ref_obj.entityName}}Mapper.instance.saveWithRef(refVar{{c.index}});
    }
{% endif %}
{% endfor %}
    return true;
  }

  @Override
  public boolean saveWithRef(List<PB{{_tbi_.entityName}}> list) {
    boolean ret = super.saveWithRef(list);
    if (!ret) {
      return false;
    }
    List vars = new ArrayList();
{% for c in _tbi_.refs %}
    Timber.d("{{c.ref_varNameC}}");
    for(int i=0; i<list.size(); i++) {
{% if c.pbrepeated %}
      List<PB{{c.ref_obj.entityName}}> refVar{{c.index}} = list.get(i).get{{c.ref_varNameC}}List();
{% else %}
      PB{{c.ref_obj.entityName}} refVar{{c.index}} = list.get(i).get{{c.ref_varNameC}}();
{% endif %}
      if (null != refVar{{c.index}}) {
        vars.add(refVar{{c.index}});
      }
    }
    PB{{c.ref_obj.entityName}}Mapper.instance.saveWithRef(vars);
    vars.clear();
{% endfor %}

    return true;
  }

  @Override
  public boolean saveWithRef(Set<PB{{_tbi_.entityName}}> set) {
    boolean ret = super.saveWithRef(set);
    if (!ret) {
      return false;
    }
    List vars = new ArrayList();
{% for c in _tbi_.refs %}
    // save city;
    Iterator<PB{{_tbi_.entityName}}> refVar{{c.index}} = set.iterator();
    while (refVar{{c.index}}.hasNext()) {
{% if c.pbrepeated %}
      List<PB{{c.ref_obj.entityName}}> v = refVar{{c.index}}.next().get{{c.ref_varNameC}}List();
{% else %}
      PB{{c.ref_obj.entityName}} v = refVar{{c.index}}.next().get{{c.ref_varNameC}}();
{% endif %}
      if (null != v) {
        vars.add(v);
      }
    }
    PB{{c.ref_obj.entityName}}Mapper.instance.saveWithRef(vars);
    vars.clear();
{% endfor %}

    return true;
  }

  @Override
  public boolean delete(PB{{_tbi_.entityName}} o) {
    if (o == null) {
      return false;
    }
    if (deleteStatement == null) {
      this.compileDeleteStatement();
    }
    deleteStatement.{{_tbi_.pkCol.sqlite3.binder}}(1, o.get{{_tbi_.pkCol.capName}}());
    int recs = deleteStatement.executeUpdateDelete();
    return (recs == 1);
  }

  @Override
  public PB{{_tbi_.entityName}} map(Cursor cursor, PB{{_tbi_.entityName}} o) {
    PB{{_tbi_.entityName}}.Builder builder = PB{{_tbi_.entityName}}.newBuilder();

    if (cursor.isBeforeFirst()) {
      cursor.moveToFirst();
    }
{% for c in _tbi_.columns %}
    builder.set{{c.capName}}(cursor.{{c.sqlite3.rsGetter()}}({{c.index}}));
{% endfor %}

    return builder.build();
  }

{% for c in _tbi_.refs %}
{% if c.ref_type == 'repeated' %}
  public void wrapRef{{c.ref_varNameC}}(List<PB{{_tbi_.entityName}}.Builder> list) {
    for (int i = 0; i < list.size(); i++) {
      PB{{_tbi_.entityName}}.Builder item = list.get(i);
      wrapRef{{c.ref_varNameC}}(item);
    }
  }
{% else %}
  public void wrapRef{{c.ref_varNameC}}(List<PB{{_tbi_.entityName}}.Builder> list) {
    Set<{{c.ref_obj.pkType}}> ids = new HashSet<{{c.ref_obj.pkType}}>();
    for (int i = 0; i < list.size(); i++) {
      PB{{_tbi_.entityName}}.Builder item = list.get(i);
      ids.add(item.get{{c.capName}}());
    }
    List<PB{{c.ref_obj.entityName}}> refList = PB{{c.ref_obj.entityName}}Mapper.instance.getsWithRef(ids);
    for (int i = 0; i < list.size(); i++) {
      PB{{_tbi_.entityName}}.Builder item = list.get(i);
      for (int j = 0; j < refList.size(); j++) {
        PB{{c.ref_obj.entityName}} targetItem = refList.get(j);
        if (targetItem.getId() == item.get{{c.capName}}()) {
          item.set{{c.ref_varNameC}}(targetItem);
          break;
        }
      }
    }
  }
{% endif %}
{% endfor %}

  @Override
  public void wrapRef(List<PB{{_tbi_.entityName}}> list) {
    if(list == null || list.size() == 0) {
      return;
    }

    List<PB{{_tbi_.entityName}}.Builder> builders = new ArrayList<PB{{_tbi_.entityName}}.Builder>();
    for(int i=0; i<list.size(); i++){
        builders.add(PB{{_tbi_.entityName}}.newBuilder(list.get(i)));
    }

{% for c in _tbi_.refs %}
    wrapRef{{c.ref_varNameC}}(builders);
{% endfor %}

  }

{% for c in _tbi_.refs %}
  public void wrapRef{{c.ref_varNameC}}(PB{{_tbi_.entityName}}.Builder builder) {
    {{c.java_type}} val = builder.get{{c.capName}}();
    if (null == val) {
      return;
    }
{% if c.ref_type == 'repeated' %}
    List<PB{{c.ref_obj.entityName}}> refItems = PB{{c.ref_obj.entityName}}Mapper.instance.getsWithRef(val);
    builder.addAll{{c.ref_varNameC}}(refItems);
{% else %}
    PB{{c.ref_obj.entityName}} refItem = PB{{c.ref_obj.entityName}}Mapper.instance.getWithRef(val);
    builder.set{{c.ref_varNameC}}(refItem);
{% endif %}

  }

{% endfor %}

  @Override
  public void wrapRef(PB{{_tbi_.entityName}} o) {
    if(o == null) {
      return;
    }
    PB{{_tbi_.entityName}}.Builder builder = PB{{_tbi_.entityName}}.newBuilder(o);
{% for c in _tbi_.refs %}
    wrapRef{{c.ref_varNameC}}(builder);
{% endfor %}
    
    o = builder.build();

  }

}
