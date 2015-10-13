#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import os
import glob
import shutil
import string
import dbm

from datetime import datetime

from jinja2 import Environment, FileSystemLoader

loader = FileSystemLoader('template')
env = Environment(loader=loader, trim_blocks=True)

SKELETON_FOLDER='skeleton'


def serve_template(name, **kwargs):
    template = env.get_template(name)
    strs = template.render(**kwargs)
    return strs.encode('utf8')


def render_template(fname, tmplname, **kwargs):
    with open(fname, 'w+') as fw:
        fw.write(serve_template(tmplname, **kwargs))

def read_tables0(prjinfo):
    if prjinfo._dbload_:
        return
        
    dbm.open(prjinfo._dburl_)
    dburl = prjinfo._dburl_.split('@')[-1]
    tbrefs = {}
    for minfo in prjinfo._modules_:
        tbs = []
        for name in minfo['tables']:
            table = dbm.get_mysql_table(minfo['db'], name)
            table.mname=minfo['ns']
            tbs.append(table)
            tbrefs[name] = table
        minfo['tables'] = tbs
        minfo['dburl'] = dburl
    
    for name in tbrefs:
        tb = tbrefs[name]
        for c in tb.refs:
            c.ref_obj = tbrefs[c.ref_obj.name]
    prjinfo._dbload_ = True

def format_line(line, prjinfo):
    try:
        line = line.decode('utf-8')
        attrs = dir(prjinfo)
        for key in attrs:
            v = getattr(prjinfo, key)
            if isinstance(v, str) or isinstance(v, unicode):
                line = line.replace(key, v)
        line = line.replace('-project-', prjinfo._project_)
        line = line.replace('-company-', prjinfo._company_)
        line = line.replace('kproject', prjinfo._project_)
        line = line.replace('kcompany', prjinfo._company_)
        return line.encode('utf-8')
    except Exception, e:
        return line


def copy_file(src, dst, prjinfo):
    with open(dst, 'w+') as fw:
        with open(src) as fr:
            for line in fr:
                fw.write(format_line(line, prjinfo))


def gen_file(src, dst, prjinfo):
    #print src
    #print dst
    if os.path.isdir(src):
        os.makedirs(dst)
    else:
        if src.endswith('.jar'):
            shutil.copyfile(src, dst)
            return
        copy_file(src, dst, prjinfo)


def upper_first(name):
    return name[0].upper() + name[1:]

def lower_first(name):
    return name[0].lower() + name[1:]

def gen_name(name, suffix=[], upperFirst=True):
    tmp = name.split('_')
    tmp.extend(suffix)
    tmp = [item[0].upper() + item[1:] for item in tmp]
    if not upperFirst:
        tmp[0] = tmp[0][0].lower() + tmp[0][1:]
    return ''.join(tmp)
