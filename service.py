#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import os
import glob
import shutil
import string
import dbm

from common import *

def render_service(fname, **kwargs):
    with open(fname, 'w+') as fw:
        fw.write(serve_template('service.mako', **kwargs))


def render_serviceImpl(fname, **kwargs):
    with open(fname, 'w+') as fw:
        fw.write(serve_template('serviceImpl.mako', **kwargs))


def render_serviceTest(fname, **kwargs):
    with open(fname, 'w+') as fw:
        fw.write(serve_template('serviceTest.mako', **kwargs))


def gen_service(prjinfo, minfo):
    outfolder = os.path.join(prjinfo._root_, 'java/service/src/main/java/com/_company_/_project_/service')
    outfolder = format_line(outfolder, prjinfo)
    fpath = os.path.join(outfolder, minfo['ns'])
    if not os.path.exists(fpath):
        os.makedirs(fpath)

    kwargs = {}
    kwargs['prj'] = prjinfo
    kwargs['emm'] = prjinfo.emm
    kwargs['minfo'] = minfo
    kwargs['_now_'] = datetime.now().strftime('%Y-%m-%d %H:%M')
    kwargs['_module_'] = minfo['ns']
    kwargs['_refs_'] = minfo['ref']

    for table in minfo['tables']:
        fname = os.path.join(fpath, table.entityName + 'Service.java')
        kwargs['_tbi_'] = table
        kwargs['_cols_'] = table.columns
        kwargs['_pks_'] = table.pks
        render_service(fname, **kwargs)


def gen_serviceImpl(prjinfo, minfo):
    outfolder = os.path.join(prjinfo._root_, 'java/serviceImpl/src/main/java/com/_company_/_project_/service/impl')
    outfolder = format_line(outfolder, prjinfo)
    fpath = os.path.join(outfolder, minfo['ns'])
    if not os.path.exists(fpath):
        os.makedirs(fpath)

    kwargs = {}
    kwargs['prj'] = prjinfo
    kwargs['emm'] = prjinfo.emm
    kwargs['minfo'] = minfo
    kwargs['_now_'] = datetime.now().strftime('%Y-%m-%d %H:%M')
    kwargs['_module_'] = minfo['ns']
    kwargs['_refs_'] = minfo['ref']

    for table in minfo['tables']:
        fname = os.path.join(fpath, table.entityName + 'ServiceImpl.java')
        kwargs['_tbi_'] = table
        kwargs['_cols_'] = table.columns
        kwargs['_pks_'] = table.pks
        render_serviceImpl(fname, **kwargs)


def start(prjinfo):
    if not os.path.exists(prjinfo._root_):
        os.makedirs(prjinfo._root_)

    read_tables(prjinfo)

    for minfo in prjinfo._modules_:
        gen_service(prjinfo, minfo)
        gen_serviceImpl(prjinfo, minfo)
