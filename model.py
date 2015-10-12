#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import os
import glob
import shutil
import string

from common import *

def gen_java_model(prjinfo, minfo):
    outfolder = os.path.join(prjinfo._root_, 'java/model/src/main/java/com/_company_/_project_/model')
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
        kwargs['_tbi_'] = table
        kwargs['_cols_'] = table.columns
        kwargs['_pks_'] = table.pks
        refs = table.refs
        if refs:
            refs2 = [c for c in refs if c.ref_obj.entityName != table.entityName]
            kwargs['_refms_'] = refs2
        else:
            kwargs['_refms_'] = []
        fname = os.path.join(fpath, 'Abstract' + table.entityName + '.java')    
        render_template(fname, 'entity-meta.mako', **kwargs)
        fname = os.path.join(fpath, table.entityName + '.java')    
        render_template(fname, 'entity.mako', **kwargs)

    # protobuf files
    outfolder = os.path.join(prjinfo._root_, 'java/model/src/resources')
    if not os.path.exists(outfolder):
        os.makedirs(outfolder)
    cmds = []
    for table in minfo['tables']:
        kwargs['_tbi_'] = table
        refs = table.refs
        if refs:
            refs2 = [c.ref_obj.entityName for c in refs if c.ref_obj.entityName != table.entityName]
            kwargs['_refms_'] = refs2
        else:
            kwargs['_refms_'] = []
        fpath = os.path.join(outfolder, table.entityName + "Proto.proto")
        if os.path.exists(fpath):
            os.remove(fpath)
        render_template(fpath, 'protobuf_entity.mako', **kwargs)
        cmds.append('sh gen.sh %s %s' % (table.entityName, minfo['ns']))

    # gen-module.sh
    fpath = os.path.join(outfolder, 'gen-' + minfo['ns'] + '.sh')
    with open(fpath, 'w+') as fw:
        for line in cmds:
            fw.write(line)
            fw.write('\n')


def gen_convertor(prjinfo, minfo):
    outfolder = os.path.join(prjinfo._root_, 'java/model/src/main/java/com/_company_/_project_/convertor')
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
        fname = os.path.join(fpath, table.entityName + 'Convertor.java')
        kwargs['_tbi_'] = table
        kwargs['_cols_'] = table.columns
        kwargs['_pks_'] = table.pks
        render_template(fname, 'entity-convertor.mako', **kwargs)


def start(prjinfo):
    if not os.path.exists(prjinfo._root_):
        os.makedirs(prjinfo._root_)
    
    read_tables(prjinfo)

    for minfo in prjinfo._modules_:
        gen_java_model(prjinfo, minfo)
        gen_convertor(prjinfo, minfo)
