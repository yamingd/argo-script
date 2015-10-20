#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import os
import glob
import shutil
import string
import dbm

from common import *

def gen_controller(prjinfo, minfo):
    outfolder = os.path.join(prjinfo._root_, 'java/_project_/web-home/src/main/java/com/_company_/_project_/web/home')
    outfolder = format_line(outfolder, prjinfo)
    fpath = os.path.join(outfolder, minfo['ns'])
    if not os.path.exists(fpath):
        os.makedirs(fpath)

    kwargs = {}
    kwargs['prj'] = prjinfo
    kwargs['minfo'] = minfo
    kwargs['_now_'] = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    kwargs['_user_'] = prjinfo._user_
    kwargs['_module_'] = minfo['ns']

    for name in minfo['tables']:
        table = prjinfo._tbrefs_[name]
        kwargs['_tbi_'] = table
        kwargs['_cols_'] = [col for col in table.columns if col.isFormField]

        fname = os.path.join(fpath, 'Home' + table.java.name + 'Controller.java')
        render_template(fname, 'home-controller.mako', **kwargs)

        fname = os.path.join(fpath, 'Home' + table.java.name + 'Form.java')
        render_template(fname, 'home-form.mako', **kwargs)


def gen_views(prjinfo, minfo):
    outfolder = os.path.join(prjinfo._root_, 'java/_project_/web-home/src/main/webapp/WEB-INF/views/home')
    outfolder = format_line(outfolder, prjinfo)
    fpath = os.path.join(outfolder, minfo['ns'])
    if not os.path.exists(fpath):
        os.makedirs(fpath)

    # views
    for name in minfo['tables']:
        table = prjinfo._tbrefs_[name]
        folder2 = os.path.join(outfolder, table.mvc_url())
        if not os.path.exists(folder2):
            os.makedirs(folder2)
        for name in ['add', 'view', 'list']:
            f = os.path.join(folder2, name + '.html')
            with open(f, 'w+') as fw:
                fw.write('<@layout.extends name="home/layout/base.html">')
                fw.write('\n')
                fw.write('</@layout.extends>')


def start(prjinfo):
    if not os.path.exists(prjinfo._root_):
        os.makedirs(prjinfo._root_)

    dbm.read_tables(prjinfo)

    for minfo in prjinfo.home:
        gen_controller(prjinfo, minfo)
        gen_views(prjinfo, minfo)
