#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import os
import glob
import shutil
import string

from common import *

def gen_files(prjinfo, folders, tmpl_path, out_path):
    _tmpl_ = tmpl_path + '/'
    for folder in folders:
        base = _tmpl_ + folder
        files = glob.glob(base + '/*')
        while files:
            fname = files.pop()
            # print fname
            dst = fname[len(_tmpl_):]
            dst = format_line(dst, prjinfo)
            dst = os.path.join(out_path, dst)
            if os.path.isdir(fname):
                gen_file(fname, dst, prjinfo)
                files.extend(glob.glob(fname + '/*'))
            else:
                gen_file(fname, dst, prjinfo)


def gen_structure(prjinfo, lang):
    fpath = SKELETON_FOLDER + '/' + lang
    opath = os.path.join(prjinfo._root_, lang)
    if not os.path.exists(opath):
        os.makedirs(opath)
    folders = os.listdir(fpath)
    #print folders
    for folder in folders:
        print 'dst: ', folder
        if folder in ['target', 'out', '.DS_Store']:
            continue
        dst = format_line(folder, prjinfo)
        gen_file(os.path.join(fpath, folder), os.path.join(opath, dst), prjinfo)
    return folders, fpath, opath


def start(prjinfo):
    if os.path.exists(prjinfo._root_):
        shutil.rmtree(prjinfo._root_)
    os.makedirs(prjinfo._root_)
    #1. java
    folders, tmpl_path, out_path = gen_structure(prjinfo, 'java')
    gen_files(prjinfo, folders, tmpl_path, out_path)
    #2. ios
    folders, tmpl_path, out_path = gen_structure(prjinfo, 'ios')
    gen_files(prjinfo, folders, tmpl_path, out_path)
    #3. android
    folders, tmpl_path, out_path = gen_structure(prjinfo, 'android')
    gen_files(prjinfo, folders, tmpl_path, out_path)
