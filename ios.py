#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import os
import glob
import shutil
import string
import dbm

from common import *

IOS_MAPPER_BASE_FOLDER = 'ios/_project_/_project_/Mappers'

# def gen_model(prjinfo, minfo):
#     outfolder = os.path.join(prjinfo._root_, 'models')
#     outfolder = format_line(outfolder, prjinfo)
#     fpath = os.path.join(outfolder, minfo['ns'])
#     if not os.path.exists(fpath):
#         os.makedirs(fpath)

#     kwargs = {}
#     kwargs['prj'] = prjinfo
#     kwargs['emm'] = prjinfo.emm
#     kwargs['minfo'] = minfo
#     kwargs['_now_'] = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
#     kwargs['_module_'] = minfo['ns']
#     kwargs['_refs_'] = minfo['ref']
    
#     for table in minfo['tables']:
#         kwargs['_tbi_'] = table
#         kwargs['_cols_'] = table.columns
#         kwargs['_pks_'] = table.pks
#         fname = os.path.join(fpath, 'TS' + table.entityName + '.hh')
#         render_template(fname, 'ios-entity-hh.mako', **kwargs)

#         fname = os.path.join(fpath, 'TS' + table.entityName + '.mm')
#         render_template(fname, 'ios-entity-mm.mako', **kwargs)


def gen_mapper(prjinfo, minfo):
    outfolder = os.path.join(prjinfo._root_, IOS_MAPPER_BASE_FOLDER)
    outfolder = format_line(outfolder, prjinfo)
    outfolder = os.path.join(outfolder, minfo['ns'])
    if not os.path.exists(outfolder):
        os.makedirs(outfolder)

    kwargs = {}
    kwargs['prj'] = prjinfo
    kwargs['minfo'] = minfo
    kwargs['_now_'] = datetime.now().strftime('%Y-%m-%d %H:%M')
    kwargs['_module_'] = minfo['ns']

    # protobuf mapper
    for table in minfo['tables']:
        kwargs['_tbi_'] = table
        fpath = os.path.join(outfolder, table.pb.name + "Mapper.h")
        if os.path.exists(fpath):
            os.remove(fpath)
        render_template(fpath, 'protobuf-ios-mapper-h.mako', **kwargs)
        fpath = os.path.join(outfolder, table.pb.name + "Mapper.m")
        if os.path.exists(fpath):
            os.remove(fpath)
        render_template(fpath, 'protobuf-ios-mapper-m.mako', **kwargs)


def gen_mapper_init(prjinfo):
    outfolder = os.path.join(prjinfo._root_, IOS_MAPPER_BASE_FOLDER)
    outfolder = format_line(outfolder, prjinfo)
    
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
    outfolder = os.path.join(prjinfo._root_, 'ios/_project_/_project_/Services')
    outfolder = format_line(outfolder, prjinfo)
    fpath = os.path.join(outfolder, minfo['ns'])
    if not os.path.exists(fpath):
        os.makedirs(fpath)

    kwargs = {}
    kwargs['prj'] = prjinfo
    kwargs['minfo'] = minfo
    kwargs['_now_'] = datetime.now().strftime('%Y-%m-%d %H:%M')
    kwargs['_module_'] = minfo['ns']
    
    for name in minfo['tables']:
        table = prjinfo._tbrefs_[name]
        kwargs['_tbi_'] = table
        fname = os.path.join(fpath, table.pb.name + 'Service.h')
        render_template(fname, 'ios-service-h.mako', **kwargs)

        fname = os.path.join(fpath, table.pb.name + 'Service.m')
        render_template(fname, 'ios-service-m.mako', **kwargs)

def gen_controller_folder(prjinfo, minfo):
    outfolder = os.path.join(prjinfo._root_, 'ios/_project_/_project_/Controllers')
    outfolder = format_line(outfolder, prjinfo)
    fpath = os.path.join(outfolder, minfo['ns'])
    if not os.path.exists(fpath):
        os.makedirs(fpath)


def start(prjinfo):
    if not os.path.exists(prjinfo._root_):
        os.makedirs(prjinfo._root_)
    
    dbm.read_tables(prjinfo)

    for minfo in prjinfo._modules_:
        gen_mapper(prjinfo, minfo)

    gen_mapper_init(prjinfo)

    for minfo in prjinfo.mobile:
        gen_service(prjinfo, minfo)
        gen_controller_folder(prjinfo, minfo)

