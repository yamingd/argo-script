#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import os
import glob
import shutil
import string
import dbm

from common import *

def render_mapperTx(fname, **kwargs):
    with open(fname, 'w+') as fw:
        fw.write(serve_template('mysqlMapperTx.mako', **kwargs))


def render_mapper(fname, **kwargs):
    with open(fname, 'w+') as fw:
        fw.write(serve_template('mysqlMapper.mako', **kwargs))


def render_mapperImpl(fname, **kwargs):
    with open(fname, 'w+') as fw:
        fw.write(serve_template('mysqlMapperImpl.mako', **kwargs))


def gen_mapper(prjinfo, minfo):
    outfolder = os.path.join(prjinfo._root_, 'java/_project_/service/src/main/java/com/_company_/_project_/mapper')
    outfolder = format_line(outfolder, prjinfo)
    fpath = os.path.join(outfolder, minfo['ns'])
    if not os.path.exists(fpath):
        os.makedirs(fpath)

    kwargs = {}
    kwargs['prj'] = prjinfo
    kwargs['emm'] = prjinfo.emm
    kwargs['minfo'] = minfo
    kwargs['_now_'] = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    kwargs['_module_'] = minfo['ns']

    for table in minfo['tables']:
        fname = os.path.join(fpath, table.java.name + 'Mapper.java')
        kwargs['_tbi_'] = table
        render_mapper(fname, **kwargs)


def gen_mapperImpl(prjinfo, minfo):
    outfolder = os.path.join(prjinfo._root_, 'java/_project_/serviceImpl/src/main/java/com/_company_/_project_/mapper/impl')
    outfolder = format_line(outfolder, prjinfo)
    fpath = os.path.join(outfolder, minfo['ns'])
    if not os.path.exists(fpath):
        os.makedirs(fpath)

    kwargs = {}
    kwargs['prj'] = prjinfo
    kwargs['emm'] = prjinfo.emm
    kwargs['minfo'] = minfo
    kwargs['_now_'] = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    kwargs['_module_'] = minfo['ns']
    kwargs['_refs_'] = minfo['ref']

    for table in minfo['tables']:
        fname = os.path.join(fpath, table.java.name + 'MapperImpl.java')
        kwargs['_tbi_'] = table
        render_mapperImpl(fname, **kwargs)
        fname = os.path.join(fpath, table.java.name + 'Tx.java')
        render_mapperTx(fname, **kwargs)


def gen_config(prjinfo, target):
    kwargs = {}
    kwargs['_modules_'] = prjinfo._modules_

    outfolder = os.path.join(prjinfo._root_, 'java/_project_/web-res/src/%s/resources' % target)
    outfolder = format_line(outfolder, prjinfo)

    fname = os.path.join(outfolder, 'mysql.yaml')
    render_template(fname, 'config-mysql.mako', **kwargs)
    
    fname = os.path.join(outfolder, 'mapper.yaml')
    render_template(fname, 'config-mapper.mako', **kwargs)


def start(prjinfo):
    if not os.path.exists(prjinfo._root_):
        os.makedirs(prjinfo._root_)

    dbm.read_tables(prjinfo)

    for minfo in prjinfo._modules_:
        gen_mapper(prjinfo, minfo)
        gen_mapperImpl(prjinfo, minfo)
    
    gen_config(prjinfo, 'main')
    gen_config(prjinfo, 'test')

