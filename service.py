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
    outfolder = os.path.join(prjinfo._root_, 'java/_project_/service/src/main/java/com/_company_/_project_/service')
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
        fname = os.path.join(fpath, table.java.name + 'Service.java')
        kwargs['_tbi_'] = table
        render_service(fname, **kwargs)


def gen_serviceImpl(prjinfo, minfo):
    outfolder = os.path.join(prjinfo._root_, 'java/_project_/serviceImpl/src/main/java/com/_company_/_project_/service/impl')
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
        fname = os.path.join(fpath, table.java.name + 'ServiceImpl.java')
        kwargs['_tbi_'] = table
        render_serviceImpl(fname, **kwargs)


def start(prjinfo):
    if not os.path.exists(prjinfo._root_):
        os.makedirs(prjinfo._root_)

    dbm.read_tables(prjinfo)

    for minfo in prjinfo._modules_:
        gen_service(prjinfo, minfo)
        gen_serviceImpl(prjinfo, minfo)
