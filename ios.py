#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import os
import glob
import shutil
import string

from common import *

IOS_MAPPER_BASE_FOLDER = 'ios/_project_/_project_/Mappers'

def gen_model(prjinfo, minfo):
    outfolder = os.path.join(prjinfo.iosfolder, 'models')
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
        fname = os.path.join(fpath, 'TS' + table.entityName + '.hh')
        render_template(fname, 'ios-entity-hh.mako', **kwargs)

        fname = os.path.join(fpath, 'TS' + table.entityName + '.mm')
        render_template(fname, 'ios-entity-mm.mako', **kwargs)


def gen_mapper(prjinfo, minfo):
    outfolder = os.path.join(prjinfo._root_, IOS_MAPPER_BASE_FOLDER)
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
    
    # protobuf mapper
    for table in minfo['tables']:
        kwargs['_tbi_'] = table
        refs = table.refs
        if refs:
            refs2 = [c for c in refs if c.ref_obj.entityName != table.entityName]
            kwargs['_refms_'] = refs2
        else:
            kwargs['_refms_'] = []
        fpath = os.path.join(outfolder, 'PB' + table.entityName + "Mapper.h")
        if os.path.exists(fpath):
            os.remove(fpath)
        render_template(fpath, 'protobuf-ios-mapper-h.mako', **kwargs)
        fpath = os.path.join(outfolder, 'PB' + table.entityName + "Mapper.m")
        if os.path.exists(fpath):
            os.remove(fpath)
        render_template(fpath, 'protobuf-ios-mapper-m.mako', **kwargs)


def gen_mapper_init(prjinfo):
    outfolder = os.path.join(prjinfo._root_, IOS_MAPPER_BASE_FOLDER)

    kwargs = {}
    kwargs['prj'] = prjinfo
    kwargs['_now_'] = datetime.now().strftime('%Y-%m-%d %H:%M')
    
    fpath = os.path.join(outfolder, 'PBMapperInit.h')
    if os.path.exists(fpath):
        os.remove(fpath)
    render_template(fpath, 'protobuf-ios-mapper-init-h.mako', **kwargs)
    fpath = os.path.join(outfolder, 'PBMapperInit.m')
    if os.path.exists(fpath):
        os.remove(fpath)
    render_template(fpath, 'protobuf-ios-mapper-init-m.mako', **kwargs)


def gen_service(prjinfo, minfo):
    outfolder = os.path.join(prjinfo.iosfolder, 'ios/_project_/_project_/Services')
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
        kwargs['_tbi_'] = table
        kwargs['_cols_'] = table.columns
        kwargs['_pks_'] = table.pks
        fname = os.path.join(fpath, table.entityName + 'Service.h')
        render_template(fname, 'ios-service-h.mako', **kwargs)

        fname = os.path.join(fpath, table.entityName + 'Service.m')
        render_template(fname, 'ios-service-m.mako', **kwargs)

def gen_controller_folder(prjinfo, minfo):
    outfolder = os.path.join(prjinfo.iosfolder, 'ios/_project_/_project_/Controllers')
    outfolder = format_line(outfolder, prjinfo)
    fpath = os.path.join(outfolder, minfo['ns'])
    if not os.path.exists(fpath):
        os.makedirs(fpath)


def start(prjinfo):
    if not os.path.exists(prjinfo._root_):
        os.makedirs(prjinfo._root_)
    
    read_tables(prjinfo)

    for minfo in prjinfo._modules_:
        gen_mapper(prjinfo, minfo)
        gen_service(prjinfo, minfo)
        gen_controller_folder(prjinfo, minfo)

    gen_mapper_init(prjinfo)

