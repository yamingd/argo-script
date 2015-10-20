#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import os
import glob
import shutil
import string
import dbm

from common import *

ANDROID_BASE_FOLDRR = 'android/_project_/app/src/main/java/com/_company_/_project_/'
ANDROID_MAPPER_BASE_FOLDRR = 'android/_project_/app/src/main/java/com/_company_/_project_/mapper'
ANDROID_EVENT_BASE_FOLDRR = 'android/_project_/app/src/main/java/com/_company_/_project_/event'
ANDROID_SERVICE_BASE_FOLDRR = 'android/_project_/app/src/main/java/com/_company_/_project_/service'


def gen_mapper(prjinfo, minfo):
    outfolder = os.path.join(prjinfo._root_, ANDROID_MAPPER_BASE_FOLDRR)
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
        fpath = os.path.join(outfolder, table.pb.name + "Mapper.java")
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
    outfolder = os.path.join(outfolder, minfo['ns'])
    if not os.path.exists(outfolder):
        os.makedirs(outfolder)

    kwargs = {}
    kwargs['prj'] = prjinfo
    kwargs['minfo'] = minfo
    kwargs['_now_'] = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    kwargs['_module_'] = minfo['ns']

    # protobuf mapper
    for name in minfo['tables']:
        table = prjinfo._tbrefs_[name]
        kwargs['_tbi_'] = table
        #
        fpath = os.path.join(outfolder, table.pb.name + "CreateResultEvent.java")
        if os.path.exists(fpath):
            os.remove(fpath)
        render_template(fpath, 'android-event-create.mako', **kwargs)
        #
        fpath = os.path.join(outfolder, table.pb.name + "DetailResultEvent.java")
        if os.path.exists(fpath):
            os.remove(fpath)
        render_template(fpath, 'android-event-detail.mako', **kwargs)
        #
        fpath = os.path.join(outfolder, table.pb.name + "ListResultEvent.java")
        if os.path.exists(fpath):
            os.remove(fpath)
        render_template(fpath, 'android-event-list.mako', **kwargs)
        #
        fpath = os.path.join(outfolder, table.pb.name + "RemoveResultEvent.java")
        if os.path.exists(fpath):
            os.remove(fpath)
        render_template(fpath, 'android-event-remove.mako', **kwargs)
        #
        fpath = os.path.join(outfolder, table.pb.name + "SaveResultEvent.java")
        if os.path.exists(fpath):
            os.remove(fpath)
        render_template(fpath, 'android-event-save.mako', **kwargs)

def gen_service(prjinfo, minfo):
    outfolder = os.path.join(prjinfo._root_, ANDROID_BASE_FOLDRR + 'service')
    outfolder = format_line(outfolder, prjinfo)
    outfolder = os.path.join(outfolder, minfo['ns'])
    if not os.path.exists(outfolder):
        os.makedirs(outfolder)

    kwargs = {}
    kwargs['prj'] = prjinfo
    kwargs['minfo'] = minfo
    kwargs['_now_'] = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    kwargs['_module_'] = minfo['ns']

    for name in minfo['tables']:
        table = prjinfo._tbrefs_[name]
        kwargs['_tbi_'] = table

        fpath = os.path.join(outfolder, table.pb.name + "Service.java")
        if os.path.exists(fpath):
            os.remove(fpath)
        render_template(fpath, 'android-service.mako', **kwargs)
        
        fpath = os.path.join(outfolder, table.pb.name + "ServiceImpl.java")
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
    
    dbm.read_tables(prjinfo)

    for minfo in prjinfo._modules_:
        gen_mapper(prjinfo, minfo)

    for minfo in prjinfo.mobile:
        gen_event(prjinfo, minfo)
        gen_service(prjinfo, minfo)
        
    gen_mapper_init(prjinfo)
    gen_core_module(prjinfo)
