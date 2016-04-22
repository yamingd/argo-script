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

def get_mysql_table_new(prj, pkg_name, db_name, tbl_name, prefix):
    global db
    sql = text(
        "SELECT table_name, table_comment FROM INFORMATION_SCHEMA.tables t WHERE table_schema=:x and table_name=:y")
    rows = db.execute(sql, x=db_name, y=tbl_name).fetchall()
    tbl = None
    for row in rows:
        tbl = platform.MySqlTable(prj, pkg_name, tbl_name, row[1], prefix)
        tbl.initJava()
        tbl.initProtobuf()
        tbl.initAndroid()
        tbl.initFMDB()
        break
    if tbl is None:
        print 'table not found. ', tbl_name
        raise

    # columns
    sql = text(
        "select column_name,column_type,is_nullable,column_key,column_default,CHARACTER_MAXIMUM_LENGTH,column_comment,Extra from INFORMATION_SCHEMA.COLUMNS where table_schema=:x and table_name=:y")
    # cursor = db.cursor()
    # cursor.execute(sql, [module['db'], tbl_name])
    rows = db.execute(sql, x=db_name, y=tbl_name).fetchall()
    #print rows
    index = 0
    for row in rows:
        c = platform.MySqlColumn(prj, pkg_name, row, index, tbl)
        c.initJava()
        c.initProtobuf()
        c.initAndroid()
        c.initFMDB()
        tbl.columns.append(c)
        tbl.cmaps[c.name] = c
        index += 1
        if c.key:
            tbl.pks.append(c)

    # index settings
    sql = text("select t.index_name, t.column_name, t.NON_UNIQUE from information_schema.statistics t where t.TABLE_SCHEMA = :x and t.TABLE_NAME = :y")
    rows = db.execute(sql, x=db_name, y=tbl_name).fetchall()
    idx = tbl.cindex
    for row in rows:
        if row[0] == 'PRIMARY':
            continue
        c = tbl.cmaps[row[1]]
        if row[0] in idx:
            idx[row[0]].append(c)
        else:
            idx[row[0]] = [row[2] == 0, c]
    tbl.initQueryFuncs()
    return tbl

def read_tables(prjinfo):
    if prjinfo._dbload_:
        return
        
    open(prjinfo._dburl_)
    dburl = prjinfo._dburl_.split('@')[-1]
    tbrefs = {}
    for minfo in prjinfo._modules_:
        tbs = []
        for name in minfo['tables']:
            table = get_mysql_table_new(prjinfo, minfo['ns'], minfo['db'], name, prjinfo._tbprefix_)
            tbs.append(table)
            tbrefs[name] = table
        minfo['tables'] = tbs
        minfo['dburl'] = dburl
    
    for t in tbrefs.values():
        t.initRef(tbrefs)
    
    prjinfo._tbrefs_ = tbrefs
    prjinfo._dbload_ = True


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
