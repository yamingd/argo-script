#!/usr/bin/env python
# -*- coding: utf-8 -*-

from optparse import OptionParser
import sys
import os
import glob
import shutil
import string
from datetime import datetime

import project
import model
import service
import admin
import mobile
import mapper
import home
import android
import ios
import protobuf

actions = {
    'project': project,
    'model': model,
    'service': service,
    'admin': admin,
    'mobile': mobile,
    'mapper': mapper,
    'home': home,
    'android': android,
    'ios': ios,
    'pb': protobuf
}

def main():
    usage = "usage: %prog [options] arg"
    parser = OptionParser(usage)
    parser.add_option("-p", "--prj", dest="conf",  
                      help="project conf filename, such as prjinfo")
    parser.add_option("-a", "--action", dest="action",
                      help="execute action")
    parser.add_option("-d", "--db",  
                      help="db name", dest="db")  
    parser.add_option("-t", "--table",  
                      help="table name", dest="table")
    (options, args) = parser.parse_args()

    #print args
    print options
    #print dir(options)

    print 'Project Cfg: ', options.conf, options.action
    prjinfo = __import__(options.conf, globals(), locals(), [], -1)
    print prjinfo
    root = os.path.join(prjinfo._output_, prjinfo._name_)
    prjinfo._root_ = root
    print prjinfo._root_
    emm = {}
    for m in prjinfo._modules_:
        for t in m['tables']:
            emm[t] = m['ns']
    prjinfo.emm = emm
    if options.action == 'init':
        if '_actions_' in dir(prjinfo):
            for act in prjinfo._actions_:
                actions[act].start(prjinfo)
        else:
            for act in actions:
                actions[act].start(prjinfo)
    else:
        act = actions[options.action]
        act.start(prjinfo)

if __name__ == '__main__':
    main()