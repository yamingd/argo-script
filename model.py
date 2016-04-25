#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import os
import glob
import shutil
import string
import dbm

from common import *

def gen_java_model(prjinfo, minfo):
    outfolder = os.path.join(prjinfo._root_, 'java/_project_/model/src/main/java/com/_company_/_project_/model')
    outfolder = format_line(outfolder, prjinfo)
    fpath = os.path.join(outfolder, minfo['ns'])
    if not os.path.exists(fpath):
        os.makedirs(fpath)

    kwargs = {}
    kwargs['prj'] = prjinfo
    kwargs['minfo'] = minfo
    kwargs['_now_'] = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    kwargs['_module_'] = minfo['ns']
    
    for table in minfo['tables']:
        kwargs['_tbi_'] = table
        fname = os.path.join(fpath, 'Abstract' + table.java.name + '.java')    
        render_template(fname, 'entity-meta.mako', **kwargs)
        fname = os.path.join(fpath, table.java.name + '.java')    
        render_template(fname, 'entity.mako', **kwargs)

def start(prjinfo):
    if not os.path.exists(prjinfo._root_):
        os.makedirs(prjinfo._root_)
    
    dbm.read_tables(prjinfo)

    for minfo in prjinfo._modules_:
        gen_java_model(prjinfo, minfo)
