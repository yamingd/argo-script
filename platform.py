#!/usr/bin/env python
# -*- coding: utf-8 -*-

import string
import mapping
import common

SQLITE3_CREATE_SQL_0 = u'create table if not exists %s(%s) WITHOUT ROWID;'

class PBClass(object):
    """docstring for PBClass"""
    def __init__(self, table):
        self.table = table
        self.comment = table.hint
        self.package = table.package
        self.name = 'PB' + common.gen_name(table.name)
        self.varName = common.lower_first(common.gen_name(table.name))


class PBField(object):
    """docstring for PBField"""
    def __init__(self, column):
        self.column = column
        self.name = column.name
        self.nameC = common.upper_first(self.name)
        self.typeName = mapping.protobuf_types.get(column.valType)
        self.mark = 'optional'
        self.package = column.package


class PBRefField(object):
    """docstring for PBField"""
    def __init__(self, ref, opb):
        self.ref = ref
        self.refpb = opb
        self.name = ref.varName
        self.typeName = opb.name
        self.mark = 'optional'
        if ref.repeated:
            self.mark = 'repeated'
        self.package = opb.package + "."


class JavaClass(object):
    """docstring for JavaClass"""
    def __init__(self, table):
        self.table = table
        self.comment = table.hint
        self.package = table.package
        self.name = common.gen_name(table.name)
        self.varName = common.lower_first(self.name)
        self.absName = 'Abstract' + self.name
    
    def dbFields(self):
        s = []
        for c in self.table.columns:
            s.append(c.name)
        return ', '.join(s)


class JavaField(object):
    """docstring for JavaField"""
    def __init__(self, column):
        self.column = column
        self.name = column.name
        self.valType = mapping.java_types.get(column.valType)
        self.setterName = common.upper_first(self.name)
        self.getterName = common.upper_first(self.name)
        self.typeName = self.valType
        if self.name.lower().endswith('date'):
            self.typeName = 'Date'

        if self.typeName != self.valType:
            self.typeDiff = True
        else:
            self.typeDiff = False

    def autoIncrementMark(self):
        return "true" if self.column.auto_increment else "false"
    
    def keyHodlerFun(self):
        if self.typeName == 'Integer':
            return 'intValue()'
        if self.typeName == 'Long':
            return 'longValue'
    
    @property
    def jdbcSetter(self):
        return mapping.jdbc_setter.get(self.column.valType)
    
    @property
    def defaultValue(self):
        if self.column.default:
            if self.column.default.startswith('0.0'):
                return self.column.default + "f"
            return self.column.default
        else:
            return 'null'

    @property
    def jdbcValueFunc(self):
        s = 'null == %s ? %s : %s'
        v = mapping.jdbc_value_funcs.get(self.column.valType, None)
        if v:
            v = v % self.name
            s = s % (self.name, self.defaultValue, v)
        else:
            s = s % (self.name, self.defaultValue, self.name)
        return s
    
    @property
    def pbValue(self):
        if self.typeName == 'Date':
            return 'dateToInt(item.get%s())' % self.getterName
        return 'item.get%s()' % self.getterName


class JavaRefField(object):
    """docstring for JavaField"""
    def __init__(self, ref, ojava):
        self.ref = ref
        self.refJava = ojava
        self.typeName = ojava.name
        self.package = ojava.package
        self.name = ref.varName
        self.nameC = common.upper_first(self.name)
        self.setterName = common.upper_first(self.name)
        self.getterName = common.upper_first(self.name)
        self.repeated = ref.repeated
        if ref.repeated:
            self.typeName = 'List<%s>' % ojava.name

    def mapper(self, o):
        if o.name == self.refJava.name:
            return "this"
        else:
            return self.refJava.varName + 'Mapper'


class MySqlTable(object):
    """docstring for MySqlTable"""
    def __init__(self, package, name, hint):
        self.package = package
        self.name = name
        self.hint = hint
        self.columns = []
        self.pks = []
        self.refFields = []  # MySqlRef
        self.impJavas = []   # JavaRefField
        self.impPBs = []     # PBRefField

    def initJava(self):
        self.java = JavaClass(self)
    
    def initProtobuf(self):
        self.pb = PBClass(self)
    
    def initAndroid(self):
        self.android = AndroidClass(self)

    def initFMDB(self):
        self.ios = iOSClass(self)

    def initRef(self, obj_pkgs):
        self.pk = self.pks[0]

        for c in self.columns:
            c.initRef(obj_pkgs)
            if c.ref:
                self.refFields.append(c.ref)
                if c.ref.table.name != self.name:
                    self.impJavas.append(c.ref)
                    self.impPBs.append(c.ref)

        tmp = {}
        for r in self.impJavas:
            tmp[r.java.typeName] = r.java.refJava
        self.impJavas = tmp.values()

        tmp = {}
        for r in self.impPBs:
            tmp[r.pb.typeName] = r.pb.refpb
        self.impPBs = tmp.values()

    def mvc_url(self):
        if hasattr(self, 'url'):
            return self.url
        url = self.name
        if url.startswith(self.package):
            url = url[len(self.package) + 1:]
        if url.endswith('_'):
            url = url[0:-1]
        url = '/'.join(url.split('_'))
        if url.endswith('/'):
            url = url[0:-1]
        if len(url) > 0:
            url = self.package + '/' + url
        else:
            url = self.package
        self.url = url + "s"
        return self.url


class MySqlRef(object):
    """docstring for RefField"""
    def __init__(self, column, obj_pkgs):
        self.column = column
        self.comment = column.comment
        i = self.comment.index('.')
        self.name = self.comment[1:i]
        self.table = obj_pkgs[self.name]
        self.varName = column.name.replace('Id', '')
        self.varNameC = common.upper_first(self.varName)
        self.repeated = column.name.endswith('s')
        self.package = column.package

        #self.varNameC = upper_first(self.varName)
        #self.mark = 'optional'  # single
        #self.ref_javatype = self.ref_obj.entityName

        #if self.name.endswith('s'):
        #    self.mark = 'repeated'  # many
        #    self.ref_javatype = 'List<%s>' % self.ref_obj.entityName
        
        self.initJava()
        self.initProtobuf()


    def initJava(self):
        self.java = JavaRefField(self, self.table.java)

    def initProtobuf(self):
        self.pb = PBRefField(self, self.table.pb)
        if self.table.name == self.column.table.name:
            self.pb.package = ""


class MySqlColumn(object):
    """docstring for MySqlColumn"""
    def __init__(self, package, row, index, table):
        self.table = table
        self.package = package
        self.name = row[0]  # column_name
        self.nameC = common.upper_first(self.name)
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
        self.valType = self.typeName.split('(')[0]
    
    @property
    def defaultTips(self):
        if self.default:
            return u'默认为: ' + self.default
        return u''

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
    
    @property
    def isString(self):
        return self.typeName.startswith('varchar') or self.typeName.startswith('text') or self.typeName.startswith('nvarchar') or self.typeName.startswith('char') or self.typeName.startswith('nchar')
    
    @property
    def isNumber(self):
        return self.java_type in ['Integer', 'Byte', 'Short', 'Long']
    
    @property
    def isFormField(self):
        return self.isString or self.ref is not None

    @property
    def validate(self):
        if self.null and self.max is None:
            return u''
        hint = []
        name = common.gen_name(self.name, upperFirst=False)
        if self.max:
            hint.append(u'@Length(min=0, max=%s, message="%s_too_long")' % (
                self.max, name))
        if not self.null and self.isString:
            hint.append('@NotEmpty(message="%s_empty")' % (name, ))
        if not self.null and self.isNumber:
            hint.append('@NotNull(message = "%s_empty")' % name)
        hint.append('')
        return '\n\t'.join(hint)

    def initRef(self, obj_pkgs):
        """
        get java, protobuf ready before initRef
        """
        if self.comment and self.comment.startswith('@'):
            self.ref = MySqlRef(self, obj_pkgs)
        else:
            self.ref = None
    
    def initJava(self):
        self.java = JavaField(self)

    def initProtobuf(self):
        self.pb = PBField(self)

    def initAndroid(self):
        self.android = AndroidField(self)
    
    def initFMDB(self):
        self.ios = iOSField(self)


class AndroidField(object):

    def __init__(self, column):
        self.column = column
        self.typeName = mapping.sqlite_types.get(column.valType, 'text')
        self.binder = mapping.android_sqlite_setter.get(column.valType, 'NULL')
        
    def bindValue(self, tag):
        s = '%s.get%s()' % (tag, self.column.pb.nameC)
        if self.typeName == 'text':
            s = 'filterNull(%s)' % s
        return s

    def rsGetter(self, typeName=None):
        if typeName is None:
            return mapping.android_sqlite_getter.get(self.column.valType, 'NULL')
        else:
            return mapping.android_sqlite_getter.get(typeName, 'NULL')


class AndroidClass(object):

    def __init__(self, table):
        self.table = table

    @property
    def createTableSql(self):
        cols = []
        for c in self.table.columns:
            if c.key:
                cols.append('%s %s PRIMARY KEY' % (c.name, c.android.typeName))
            else:
                cols.append('%s %s' % (c.name, c.android.typeName))
        s = SQLITE3_CREATE_SQL_0 % (self.table.name, ', '.join(cols))
        return s


class Sqlite3Column(object):

    def __init__(self, column):
        self.column = column
        self.typeName = mapping.sqlite_types.get(column.valType, 'text')
        self.binder = mapping.sqlite_setter.get(column.valType, 'NULL')
        
    def bindValue(self, tag):
        s = '%s.get%s()' % (tag, self.column.capName)
        if self.typeName == 'text':
            s = 'filterNull(%s)' % s
        return s

    def rsGetter(self, typeName=None):
        if typeName is None:
            return mapping.sqlite_getter.get(self.column.valType, 'NULL')
        else:
            return mapping.sqlite_getter.get(typeName, 'NULL')


class Sqlite3Table(object):

	def __init__(self, table):
		self.table = table
		cols = []
		for c in table.columns:
			if c.key:
				cols.append('%s %s PRIMARY KEY' % (c.name, c.sqlite3.typeName))
			else:
				cols.append('%s %s' % (c.name, c.sqlite3.typeName))
		self.createTableSql = SQLITE3_CREATE_SQL_0 % (table.name, ', '.join(cols))


class iOSField(object):

    def __init__(self, column):
        self.column = column
        self.typeName = mapping.ios_types.get(column.valType, '')
        self.pbType = mapping.protobuf_types.get(column.valType, '')
        self.typeRef = self.typeName
        if self.typeName.startswith('NS'):
        	self.typeRef = self.typeName + "*"
        self.rsGetter = mapping.pb_fmdb_getter.get(self.pbType, '')
    
    def valExp(self, tag):
        e = '@(%s.%s)' % (tag, self.column.name)
        if self.pbType == 'string':
            e = '%s.%s' % (tag, self.column.name)
        return e


class iOSClass(object):

    def __init__(self, table):
        self.table = table
    
    def columns(self):
        return ["@\"%s\"" % c.name for c in self.table.columns]
    
    def columnsInfo(self):
        tmp = ["@\"%s\": @\"%s\"" % (c.name, c.ios.typeName) for c in self.table.columns]
        tmp = ", ".join(tmp)
        return "@{%s}" % tmp
