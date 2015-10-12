#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import os
import glob
import shutil
import string

from common import *

def gen_sh(prjinfo, base_folder, tmpl_name):
    kwargs = {}
    kwargs['prj'] = prjinfo
    kwargs['emm'] = prjinfo.emm
    kwargs['_now_'] = datetime.now().strftime('%Y-%m-%d %H:%M:%S')

    # protobuf files
    outfolder = os.path.join(prjinfo._root_, base_folder)
    outfolder = format_line(outfolder, prjinfo)
    if not os.path.exists(outfolder):
        os.makedirs(outfolder)

    fpath = os.path.join(outfolder, "gen.sh")
    if os.path.exists(fpath):
        os.remove(fpath)
    render_template(fpath, tmpl_name, **kwargs)


def gen_proto(prjinfo, minfo, base_folder, lang):

    kwargs = {}
    kwargs['prj'] = prjinfo
    kwargs['emm'] = prjinfo.emm
    kwargs['minfo'] = minfo
    kwargs['_now_'] = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    kwargs['_module_'] = minfo['ns']
    kwargs['_refs_'] = minfo['ref']

    # protobuf files
    outfolder = os.path.join(prjinfo._root_, base_folder)
    outfolder = format_line(outfolder, prjinfo)
    if not os.path.exists(outfolder):
        os.makedirs(outfolder)
    cmds = []
    for table in minfo['tables']:
        kwargs['_tbi_'] = table
        refs = table.refs
        if refs:
            refs2 = [c.ref_obj.entityName for c in refs if c.ref_obj.entityName != table.entityName]
            kwargs['_refms_'] = set(refs2)
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
        fw.write('#!/usr/bin/env bash')
        fw.write('\n\n')
        for line in cmds:
            fw.write(line)
            fw.write('\n')
    # to run sh

def run_sh(prjinfo):
    fpath = os.path.join(prjinfo._root_, "pb-gen.sh")
    if os.path.exists(fpath):
        os.remove(fpath)

    kwargs = {}
    kwargs['prj'] = prjinfo
    render_template(fpath, 'sh-run.mako', **kwargs)


def start(prjinfo):
    if not os.path.exists(prjinfo._root_):
        os.makedirs(prjinfo._root_)
    
    read_tables(prjinfo)

    java_base = 'java/_project_/model/src/script'
    android_base = 'android/_project_/app/src/script'
    ios_base = 'ios/_project_/_project_/Script'

    gen_sh(prjinfo, java_base, 'protobuf-sh-java.mako')
    gen_sh(prjinfo, android_base, 'protobuf-sh-android.mako')
    gen_sh(prjinfo, ios_base, 'protobuf-sh-ios.mako')

    for minfo in prjinfo._modules_:
        gen_proto(prjinfo, minfo, java_base, 'java')
        gen_proto(prjinfo, minfo, android_base, 'android')
        gen_proto(prjinfo, minfo, ios_base, 'ios')
    
    run_sh(prjinfo)
