#!/usr/bin/env python
# -*- coding: utf-8 -*-

from sqlalchemy import create_engine
from sqlalchemy.sql import text
import string
import mapping
import platform

db = None
dbtype = 'mysql'
URL_TP = 'mysql://%s/INFORMATION_SCHEMA?charset=utf8'

def open(dburl):
    """
    http://docs.sqlalchemy.org/en/rel_0_9/core/engines.html
    """
    global db, dbtype
    print dburl
    url = URL_TP % dburl
    engine = create_engine(url, echo=True, encoding="utf-8", convert_unicode=True)
    db = engine.connect()
    return db


class Column(object):

    """docstring for Column"""

    def __init__(self, row, index):
        self.name = row[0]  # column_name
        self.typeName = row[1]  # column_type
        self.null = row[2] == 'YES' or row[2] == '1'  # is_nullable
        self.key = row[3] and (row[3] == 'PRI' or row[3] == '1')  # column_key
        self.default = row[4] if row[4] else None  # column_default
        self.max = row[5] if row[5] else None
        self.comment = row[6]
        self.extra = row[7]
        self.auto_increment = row[7] == 'auto_increment'
        self.index = index
        self.lname = self.name.lower()
        if self.default == 'CURRENT_TIMESTAMP':
            self.default = None
        if self.comment and self.comment.startswith('@'):
            i = self.comment.index('.')
            self.ref_obj = Table(self.comment[1:i], '')
            self.ref_varName = self.name.replace('Id', '')
            self.ref_varNameC = self.ref_varName[0].upper() + self.ref_varName[1:]
            self.ref_type = 'optional'  # single
            self.ref_javatype = self.ref_obj.entityName
            self.pbrepeated = False
            if self.name.endswith('s'):
                self.pbrepeated = True
                self.ref_type = 'repeated'  # many
                self.ref_javatype = 'List<%s>' % self.ref_obj.entityName
        else:
            self.ref_obj = None
        
        self.typeMapping()
        self.sqlite3 = platform.Sqlite3Column(self)
        self.ios = platform.iOSColumn(self)
    
    def typeMapping(self):
        tname = self.typeName.split('(')[0]
        self.valType = tname
        self.valTypeR = mapping.java_types.get(tname, 'String')
        if self.name.endswith('Date') or self.name.endswith('date'):
            self.java_type = 'Date'
        else:
            self.java_type = mapping.java_types.get(tname, 'String')

    @property
    def columnMark(self):
        vals = []
        if self.key:
            vals.append('pk = true')
            if self.auto_increment:
                vals.append('autoIncrement=true')
        else:
            if self.max:
                vals.append("maxLength=\"%s\"" % self.max)
            if not self.null:
                vals.append("nullable = false")
            if self.default and len(self.default) > 0:
                vals.append("defaultVal = \"%s\"" % self.default)
        if len(vals) > 0:
            return '@Column(%s)\n\t' % (', '.join(vals), )
        return '@Column\n\t'

    def pkAutoFlag(self):
        return "true" if self.auto_increment else "false"
    
    def keyHodlerFun(self):
        if self.java_type == 'Integer':
            return 'intValue()'
        if self.java_type == 'Long':
            return 'longValue'

    @property
    def protobuf_value(self):
        if self.java_type == 'Date':
            return 'dateToInt(item.get%s())' % self.capName
        return 'item.get%s()' % self.capName

    @property
    def protobuf_type(self):
        tname = self.valType
        return mapping.protobuf_types.get(tname, 'string')

    @property
    def protobuf_name(self):
        if self.lname in ['typeid', 'typename']:
            return self.lname + '_'
        return self.lname

    def refJavaMapper(self, current):
        v = self.ref_obj.varName
        if v == current:
            return "this"
        else:
            return v + "Mapper"

    @property
    def cpp_type(self):
        tname = self.valType
        return mapping.cpp_types.get(tname, '')

    @property
    def cpp_objc(self):
        tname = self.valType
        return mapping.cpp_objcs.get(tname, '')

    @property
    def objc_cpp(self):
        tname = self.valType
        return mapping.objc_cpps.get(tname, '')

    @property
    def capName(self):
        return java_name(self.name)

    @property
    def sqlSetter(self):
        tname = self.valType
        return mapping.sql_setter.get(tname)
    
    @property
    def defaultValue(self):
        if self.default:
            if self.default.startswith('0.0'):
                return self.default + "f"
            return self.default
        else:
            return 'null'

    @property
    def sqlValueSetter(self):
        s = 'null == %s ? %s : %s'
        v = mapping.value_setter.get(self.valType, None)
        if v:
            v = v % self.name
            s = s % (self.name, self.defaultValue, v)
        else:
            s = s % (self.name, self.defaultValue, self.name)
        return s

    @property
    def defaultTips(self):
        if self.default:
            return u'默认为: ' + self.default
        return u''

    @property
    def isString(self):
        return self.typeName.startswith('varchar') or self.typeName.startswith('text') or self.typeName.startswith('nvarchar') or self.typeName.startswith('char') or self.typeName.startswith('nchar')
    
    @property
    def isNumber(self):
        return self.java_type in ['Integer', 'Byte', 'Short', 'Long']
    
    @property
    def isFormField(self):
        return self.isString or self.ref_obj is not None

    @property
    def validate(self):
        if self.null and self.max is None:
            return u''
        hint = []
        name = java_name(self.name, upperFirst=False)
        if self.max:
            hint.append(u'@Length(min=0, max=%s, message="%s_too_long")' % (
                self.max, name))
        if not self.null and self.isString:
            hint.append('@NotEmpty(message="%s_empty")' % (name, ))
        if not self.null and self.isNumber:
            hint.append('@NotNull(message = "%s_empty")' % name)
        hint.append('')
        return '\n\t'.join(hint)


class Table(object):

    """docstring for Table"""

    def __init__(self, name, hint):
        self.name = name
        self.hint = hint
        self.pks = []

    @property
    def capName(self):
        return java_name(self.name)

    @property
    def varName(self):
        return java_name(self.name, upperFirst=False)

    @property
    def entityName(self):
        return java_name(self.name)

    @property
    def serviceName(self):
        return self.capName + 'Service'

    @property
    def serviceImplName(self):
        return self.capName + 'ServiceImpl'

    @property
    def controllerName(self):
        return self.capName + 'Controller'

    @property
    def pkType(self):
        if self.pks:
            return self.pks[0].java_type
        return ''

    @property
    def pkCol(self):
        if self.pks and len(self.pks) == 1:
            return self.pks[0]
        return None

    def insertColumns(self):
        return [col for col in self.columns if not col.key]

    def protobufRefAs(self, kind):
        if kind == 'repeated':
            return 'RLMArray<TS%s>*' % self.entityName
        else:
            return 'TS%s*' % self.entityName

    def refImport(self):
        cs = []
        for c in self.refs:
            cs.append(c.ref_obj.entityName)
        cs = list(set(cs))
        return cs

    def refPrefix(self, current, emm):
        if self.name == current.name:
            return ""
        return "%s." % emm[self.name]

    def mvc_url(self):
        if hasattr(self, 'url'):
            return self.url
        url = self.name
        if url.startswith(self.mname):
            url = url[len(self.mname) + 1:]
        if url.endswith('_'):
            url = url[0:-1]
        url = '/'.join(url.split('_'))
        if url.endswith('/'):
            url = url[0:-1]
        if len(url) > 0:
            url = self.mname + '/' + url
        else:
            url = self.mname
        self.url = url + "s"
        return url
    
    def sql_fields(self):
        s = []
        for c in self.columns:
            s.append(c.name)
        return ', '.join(s)
    

def get_mysql_table(db_name, tbl_name):
    global db
    sql = text(
        "SELECT table_name, table_comment FROM INFORMATION_SCHEMA.tables t WHERE table_schema=:x and table_name=:y")
    rows = db.execute(sql, x=db_name, y=tbl_name).fetchall()
    tbl = None
    for row in rows:
        tbl = Table(tbl_name, row[1])
        break
    if tbl is None:
        print 'table not found. ', tbl_name
        raise
    sql = text(
        "select column_name,column_type,is_nullable,column_key,column_default,CHARACTER_MAXIMUM_LENGTH,column_comment,Extra from INFORMATION_SCHEMA.COLUMNS where table_schema=:x and table_name=:y")
    # cursor = db.cursor()
    # cursor.execute(sql, [module['db'], tbl_name])
    rows = db.execute(sql, x=db_name, y=tbl_name).fetchall()
    print rows
    cols = []
    pks = []
    refs = []
    index = 0
    for row in rows:
        c = Column(row, index)
        cols.append(c)
        index += 1
        if c.key:
            pks.append(c)
        if c.ref_obj:
            refs.append(c)
    tbl.columns = cols
    tbl.pks = pks
    tbl.refs = refs
    tbl.mname = db_name
    tbl.sqlite3 = platform.Sqlite3Table(tbl)
    tbl.ios = platform.iOSTable(tbl)
    return tbl


def get_mssql_table(module, tbl_name):
    global db
    sql = text(
        "SELECT t.name,e.value as comment FROM sys.tables t, sys.extended_properties e WHERE t.object_id = e.major_id and e.minor_id=0 and t.object_id = OBJECT_ID(:x)")
    rows = db.execute(sql, x=tbl_name).fetchall()
    tbl = None
    for row in rows:
        tbl = Table(tbl_name, row[1])
        break
    if tbl is None:
        print 'table not found. ', tbl_name
        raise
    sql = text(
        "select c.name as column_name, ty.name as column_type, c.is_nullable, c.is_identity, '' as column_default, c.max_length, e.value as comment from sys.columns c, sys.extended_properties e, sys.systypes ty where c.object_id = OBJECT_ID(:x) and ty.xusertype = c.user_type_id and c.object_id = e.major_id and e.minor_id = c.column_id")
    rows = db.execute(sql, x=tbl_name).fetchall()
    print rows
    cols = []
    pks = []
    refs = []
    index = 0
    for row in rows:
        c = Column(row, index)
        cols.append(c)
        index += 1
        if c.key:
            pks.append(c)
        if c.ref_obj:
            refs.append(c)
    tbl.columns = cols
    tbl.pks = pks
    tbl.refs = refs
    tbl.mname = module['name']
    tbl.ios = platform.iOSTable(tbl)
    return tbl


def get_table(module, tbl_name):
    if dbtype.startswith('mysql'):
        return get_mysql_table(module, tbl_name)
    elif dbtype.startswith('mssql'):
        return get_mssql_table(module, tbl_name)
    

def java_name(tbl_name, suffix=[], upperFirst=True):
    tmp = tbl_name.split('_')
    tmp.extend(suffix)
    tmp = [item[0].upper() + item[1:] for item in tmp]
    if not upperFirst:
        tmp[0] = tmp[0][0].lower() + tmp[0][1:]
    return ''.join(tmp)
