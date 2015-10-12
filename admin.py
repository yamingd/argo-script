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
    outfolder = os.path.join(prjinfo._root_, 'java/_project_/web-admin/src/main/java/com/_company_/_project_/web/admin')
    outfolder = format_line(outfolder, prjinfo)
    fpath = os.path.join(outfolder, minfo['ns'])
    if not os.path.exists(fpath):
        os.makedirs(fpath)

    kwargs = {}
    kwargs['prj'] = prjinfo
    kwargs['emm'] = prjinfo.emm
    kwargs['minfo'] = minfo
    kwargs['_now_'] = datetime.now().strftime('%Y-%m-%d %H:%M')
    kwargs['_user_'] = prjinfo._user_
    kwargs['_module_'] = minfo['ns']
    kwargs['_refs_'] = minfo['ref']

    for table in minfo['tables']:
        kwargs['_tbi_'] = table
        kwargs['_cols_'] = [col for col in table.columns if col.isFormField]
        kwargs['_pks_'] = table.pks

        fname = os.path.join(fpath, 'Admin' + table.entityName + 'Controller.java')
        render_template(fname, 'admin-controller.mako', **kwargs)

        fname = os.path.join(fpath, 'Admin' + table.entityName + 'Form.java')
        render_template(fname, 'admin-form.mako', **kwargs)


def gen_views(prjinfo, minfo):
    outfolder = os.path.join(prjinfo._root_, 'java/_project_/web-admin/src/main/webapp/WEB-INF/views/admin')
    outfolder = format_line(outfolder, prjinfo)
    fpath = os.path.join(outfolder, minfo['ns'])
    if not os.path.exists(fpath):
        os.makedirs(fpath)

    # views
    for table in minfo['tables']:
        folder2 = os.path.join(outfolder, table.mvc_url())
        if not os.path.exists(folder2):
            os.makedirs(folder2)
        for name in ['add', 'view', 'list']:
            f = os.path.join(folder2, name + '.html')
            with open(f, 'w+') as fw:
                fw.write('<@layout.extends name="admin/layout/base.html">')
                fw.write('\n')
                fw.write('</@layout.extends>')


def start(prjinfo):
    if not os.path.exists(prjinfo._root_):
        os.makedirs(prjinfo._root_)

    read_tables(prjinfo)

    for minfo in prjinfo._modules_:
        gen_controller(prjinfo, minfo)
        gen_views(prjinfo, minfo)
