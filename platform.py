#!/usr/bin/env python
# -*- coding: utf-8 -*-

import string
import mapping
from common import gen_name, upper_first, lower_first

SQLITE3_CREATE_SQL_0 = u'create table if not exists %s(%s) WITHOUT ROWID;'

class PBClass(object):
    """docstring for PBClass"""
    def __init__(self, package, table):
        self.table = table
        self.comment = table.hint
        self.package = package
        self.name = 'PB' + gen_name(table.name)


class PBField(object):
    """docstring for PBField"""
    def __init__(self, column):
        self.column = column
        self.name = column.name
        self.typeName = mapping.protobuf_types.get(column.valType)
        self.mark = 'optional'


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


class JavaClass(object):
    """docstring for JavaClass"""
    def __init__(self, table):
        self.table = table
        self.comment = table.hint
        self.package = table.package
        self.name = gen_name(table.name)
        self.absName = 'Abstract' + self.name


class JavaField(object):
    """docstring for JavaField"""
    def __init__(self, column):
        self.column = column
        self.name = column.name
        self.typeName = mapping.java_types.get(column.valType)
        self.setterName = upper_first(self.name)
        self.getterName = upper_first(self.name)


class JavaRefField(object):
    """docstring for JavaField"""
    def __init__(self, ref, ojava):
        self.ref = ref
        self.refJava = ojava
        self.typeName = ojava.name
        self.name = ref.varName
        self.setterName = upper_first(self.name)
        self.getterName = upper_first(self.name)
        if ref.repeated:
            self.typeName = 'List<%s>' % ojava.name


class MySqlTable(object):
    """docstring for MySqlTable"""
    def __init__(self, package, name, hint):
        self.package = package
        self.name = name
        self.hint = hint
        self.columns = []
        self.pks = []
        self.refFields = []
        self.refTypes = []
    
    def initJava(self):
        self.java = JavaClass(self)
    
    def initProtobuf(self):
        self.pb = PBClass(self)


class MySqlRef(object):
    """docstring for RefField"""
    def __init__(self, column, obj_pkgs):
        self.column = column
        self.comment = column.comment
        i = self.comment.index('.')
        self.name = self.comment[1:i]
        self.table = obj_pkgs[name]
        self.varName = column.name.replace('Id', '')
        self.repeated = column.name.endswith('s')

        #self.varNameC = upper_first(self.varName)
        #self.mark = 'optional'  # single
        #self.ref_javatype = self.ref_obj.entityName

        #if self.name.endswith('s'):
        #    self.mark = 'repeated'  # many
        #    self.ref_javatype = 'List<%s>' % self.ref_obj.entityName
    
    def initJava(self):
        self.java = JavaRefField(self, self.table.java)

    def initProtobuf(self):
        self.pb = PBRefField(self, self.table.pb)


class MySqlColumn(object):
    """docstring for MySqlColumn"""
    def __init__(self, package, row, index):
        self.package = package
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
        self.valType = self.typeName.split('(')[0]
    
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

    def initAndroidSqlite(self):
        pass
    
    def initFMDB(self):
        pass


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


class iOSColumn(object):

    def __init__(self, column):
        self.column = column
        self.typeName = mapping.ios_types.get(column.valType, '')
        self.pbType = mapping.protobuf_types.get(column.valType, '')
        self.typeRef = self.typeName
        if self.typeName.startswith('NS'):
        	self.typeRef = self.typeName + "*"
        self.rsGetter = mapping.fmdb_getter.get(column.valType, '')
    
    def valExp(self, tag):
        e = '@(%s.%s)' % (tag, self.column.name)
        if self.pbType == 'string':
            e = '%s.%s' % (tag, self.column.name)
        return e


class iOSTable(object):

    def __init__(self, table):
        self.table = table
        self.columns = ["@\"%s\"" % c.name for c in table.columns]
    
    def columnsInfo(self):
        tmp = ["@\"%s\": @\"%s\"" % (c.name, c.sqlite3.typeName) for c in self.table.columns]
        tmp = ", ".join(tmp)
        return "@{%s}" % tmp
