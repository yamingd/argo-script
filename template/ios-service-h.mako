//
//  {{_tbi_.pb.name}}Service.h
//  com.{{prj._company_}}.{{prj._name_}}
//
//  Created by {{_user_}} on {{_now_}}.
//  Copyright (c). All rights reserved.
//

#import <Foundation/Foundation.h>

#import "APIClient.h"
#import "ServiceBase.h"
#import "{{_tbi_.pb.name}}Proto.pb.h"
#import "{{_tbi_.pb.name}}Mapper.h"

@interface {{_tbi_.pb.name}}Service : ServiceBase

#pragma mark - Query/Find

// 读取最新的
+(void)findLatest:(long)cursorId withCallback:(APIResponseBlock)block;

// 读取更多的(page从2开始)
+(void)findMore:(int)page cursorId:(long)cursorId withCallback:(APIResponseBlock)block;

// 主键查找
+(void)findBy:({{ _tbi_.pk.ios.typeName }})itemId withRef:(BOOL)withRef withCallback:(APIResponseBlock)block;

// 从服务器读取
+(void)loadBy:({{ _tbi_.pk.ios.typeName }})itemId withCallback:(APIResponseBlock)block;

#pragma mark - Create

// 新建
+(void)create:({{_tbi_.pb.name}}*)item withCallback:(APIResponseBlock)block;
// 更新
+(void)save:({{_tbi_.pb.name}}*)item withCallback:(APIResponseBlock)block;

#pragma mark - Remove

// 删除
+(void)remove:({{_tbi_.pb.name}}*)item withCallback:(APIResponseBlock)block;


@end
