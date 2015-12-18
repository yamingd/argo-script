#!/usr/bin/env python
# -*- coding: utf-8 -*-

settings = {
    '_project_': 'yisharer',
    '_Project_': 'Yisharer',
    '_company_': 'inno',
    'company': 'inno',
    'Company': 'Inno',
    '_output_': '../gen',
    '_dburl_': 'mysql://dev:yisharer_dev@127.0.0.1:33060/%s?charset=utf8',
    '_order_': ['catalog', 'file', 'logging', 'member', 'center'],
    '_modules_': {
        'catalog': {
            'db': 'dev_yi_member',
            'tables': ['catalog', 'country', 'province', 'city'],
            'ref': []
        },
        'file': {
            'db': 'dev_yi_file',
            'tables': ['attachment'],
            'ref': []
        },
        'logging': {
            'db': 'dev_yi_logging',
            'tables': ['log_op', 'log_email'],
            'ref': []
        },
        'member': {
            'db': 'dev_yi_member',
            'tables': ['user', 'user_friend', 'score',
                       'invitation', 'event', 'person'],
            'ref': ['file', 'catalog']
        },
        'center': {
            'db': 'dev_yi_center',
            'tables': ['design', 'design_comment', 'design_like', 'design_view',
                       'share', 'share_like', 'share_comment', 'kit', 'article'],
            'ref': ['file', 'member', 'catalog']
        },
        'mall': {
            'db': 'dev_yi_center',
            'tables': ['cart', 'cart_item', 'order', 'order_item',
                       'payment'],
            'ref': ['file', 'member', 'catalog']
        }
    },
    '_mobile_': {
        'catalog': {
            'db': 'dev_yi_member',
            'tables': ['catalog', 'country', 'province', 'city'],
            'ref': []
        },
        'file': {
            'db': 'dev_yi_file',
            'tables': ['attachment'],
            'ref': []
        },
        'member': {
            'db': 'dev_yi_member',
            'tables': ['user', 'user_friend', 'invitation', 'person'],
            'ref': ['file']
        },
        'center': {
            'db': 'dev_yi_center',
            'tables': ['design', 'design_comment', 'design_like', 'design_view',
                       'share', 'share_like', 'share_comment', 'kit', 'article'],
            'ref': ['file', 'member']
        },
        'mall': {
            'db': 'dev_yi_center',
            'tables': ['cart', 'cart_item', 'order', 'order_item',
                       'payment'],
            'ref': ['file', 'member', 'catalog']
        }
    },
    '_pc_': {
        'catalog': {
            'db': 'dev_yi_member',
            'tables': ['catalog', 'country', 'province', 'city'],
            'ref': []
        },
        'file': {
            'db': 'dev_yi_file',
            'tables': ['attachment'],
            'ref': []
        },
        'member': {
            'db': 'dev_yi_member',
            'tables': ['user', 'user_friend', 'invitation', 'person'],
            'ref': ['file']
        },
        'center': {
            'db': 'dev_yi_center',
            'tables': ['design', 'design_comment', 'design_like', 'design_view',
                       'share', 'share_like', 'share_comment', 'kit', 'article'],
            'ref': ['file', 'member']
        },
        'mall': {
            'db': 'dev_yi_center',
            'tables': ['cart', 'cart_item', 'order', 'order_item',
                       'payment'],
            'ref': ['file', 'member', 'catalog']
        }
    },
    '_sqlite3_': {}
}
