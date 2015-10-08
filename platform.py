#!/usr/bin/env python
# -*- coding: utf-8 -*-

import string
import mapping

SQLITE3_CREATE_SQL_0 = u'create table if not exists %s(%s) WITHOUT ROWID;'

class Sqlite3Column(object):

    def __init__(self, column):
        self.column = column
        self.typeName = mapping.sqlite_types.get(column.valType, 'text')
        self.binder = mapping.sqlite_setter.get(column.valType, 'NULL')
        self.rsGetter = mapping.sqlite_getter.get(column.valType, 'NULL')
        self.bindValue = 'get%s()' % column.capName
        if self.typeName == 'text':
        	self.bindValue = 'filterNull(%s)' % self.bindValue

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
        self.typeRef = self.typeName
        if self.typeName.startswith('NS'):
        	self.typeRef = self.typeName + "*"
        self.rsGetter = mapping.fmdb_getter.get(column.valType, '')
    
    def valExp(self, tag):
        e = '@(%s.%s)' % (tag, self.column.name)
        if self.typeName.startswith('NS'):
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
