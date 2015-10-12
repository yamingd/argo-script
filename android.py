#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import os
import glob
import shutil
import string

from common import *

ANDROID_BASE_FOLDRR = 'android/_project_/app/src/main/java/com/_company_/_project_/'
ANDROID_MAPPER_BASE_FOLDRR = 'android/_project_/app/src/main/java/com/_company_/_project_/mapper'
ANDROID_EVENT_BASE_FOLDRR = 'android/_project_/app/src/main/java/com/_company_/_project_/event'
ANDROID_SERVICE_BASE_FOLDRR = 'android/_project_/app/src/main/java/com/_company_/_project_/service'


def gen_mapper(prjinfo, minfo):
    outfolder = os.path.join(prjinfo._root_, ANDROID_MAPPER_BASE_FOLDRR)
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
        fpath = os.path.join(outfolder, 'PB' + table.entityName + "Mapper.java")
        if os.path.exists(fpath):
            os.remove(fpath)
        render_template(fpath, 'protobuf-android-mapper.mako', **kwargs)


def gen_mapper_init(prjinfo):
    outfolder = os.path.join(prjinfo._root_, ANDROID_MAPPER_BASE_FOLDRR)
    outfolder = format_line(outfolder, prjinfo)

    kwargs = {}
    kwargs['prj'] = prjinfo
    kwargs['_now_'] = datetime.now().strftime('%Y-%m-%d %H:%M')
    
    fpath = os.path.join(outfolder, 'PBMapperInit.java')
    if os.path.exists(fpath):
        os.remove(fpath)
    render_template(fpath, 'protobuf-android-mapper-init.mako', **kwargs)

def gen_event(prjinfo, minfo):
    outfolder = os.path.join(prjinfo._root_, ANDROID_BASE_FOLDRR + 'event')
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
    
    # protobuf mapper
    for table in minfo['tables']:
        kwargs['_tbi_'] = table
        #
        fpath = os.path.join(outfolder, table.entityName + "CreateResultEvent.java")
        if os.path.exists(fpath):
            os.remove(fpath)
        render_template(fpath, 'android-event-create.mako', **kwargs)
        #
        fpath = os.path.join(outfolder, table.entityName + "DetailResultEvent.java")
        if os.path.exists(fpath):
            os.remove(fpath)
        render_template(fpath, 'android-event-detail.mako', **kwargs)
        #
        fpath = os.path.join(outfolder, table.entityName + "ListResultEvent.java")
        if os.path.exists(fpath):
            os.remove(fpath)
        render_template(fpath, 'android-event-list.mako', **kwargs)
        #
        fpath = os.path.join(outfolder, table.entityName + "RemoveResultEvent.java")
        if os.path.exists(fpath):
            os.remove(fpath)
        render_template(fpath, 'android-event-remove.mako', **kwargs)
        #
        fpath = os.path.join(outfolder, table.entityName + "SaveResultEvent.java")
        if os.path.exists(fpath):
            os.remove(fpath)
        render_template(fpath, 'android-event-save.mako', **kwargs)

def gen_service(prjinfo, minfo):
    outfolder = os.path.join(prjinfo._root_, ANDROID_BASE_FOLDRR + 'service')
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

        fpath = os.path.join(outfolder, 'PB' + table.entityName + "Service.java")
        if os.path.exists(fpath):
            os.remove(fpath)
        render_template(fpath, 'android-service.mako', **kwargs)
        
        fpath = os.path.join(outfolder, 'PB' + table.entityName + "ServiceImpl.java")
        if os.path.exists(fpath):
            os.remove(fpath)
        render_template(fpath, 'android-service-impl.mako', **kwargs)

def gen_core_module(prjinfo):
    outfolder = os.path.join(prjinfo._root_, ANDROID_BASE_FOLDRR)
    outfolder = format_line(outfolder, prjinfo)
    
    kwargs = {}
    kwargs['prj'] = prjinfo
    kwargs['_now_'] = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    
    fpath = os.path.join(outfolder, 'CoreModule.java')
    if os.path.exists(fpath):
        os.remove(fpath)
    render_template(fpath, 'android-core-module.mako', **kwargs)


def start(prjinfo):
    if not os.path.exists(prjinfo._root_):
        os.makedirs(prjinfo._root_)
    
    read_tables(prjinfo)

    for minfo in prjinfo._modules_:
        gen_mapper(prjinfo, minfo)
        gen_event(prjinfo, minfo)
        gen_service(prjinfo, minfo)
        
    gen_mapper_init(prjinfo)
    gen_core_module(prjinfo)
