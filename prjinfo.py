#!/usr/bin/env python
# -*- coding: utf-8 -*-

_name_ = 'test'
_Name_ = 'Test'
_project_ = 'test'
_title_ = u'测试项目'
_company_ = 'inno'
_Company_ = 'Inno'
_user_ = 'user'

_output_ = 'output'
# _dburl_ = 'mysql://devtest:123456@127.0.0.1:3306/INFORMATION_SCHEMA?charset=utf8'
_dbtype_ = 'mysql'
_dburl_ = 'devtest:123456@127.0.0.1:3306'
_dbload_ = False
_tbrefs_ = {}

_apps_ = ['mobile', 'home', 'wx', 'admin']

ios = {}
android = {}

_modules_ = [
	{
		'ns': 'account',
		'db': 'ewash',
		'tables': ['person', 'address', 'wx_menu', 'wx_user'],
		'ref': []
	}
]

mobile = [
	{
	    'ns': 'account',
	    'tables': []
	}
]

admin = [
	{
	    'ns': 'account',
	    'tables': []
	}
]

home = [
	{
	    'ns': 'account',
	    'tables': []
	}
]

wx = [
	{
	    'ns': 'account',
	    'tables': []
	}
]
