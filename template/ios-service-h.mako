//
//  {{_tbi_.entityName}}Service.h
//  com.{{prj._company_}}.{{prj._name_}}
//
//  Created by {{_user_}} on {{_now_}}.
//  Copyright (c). All rights reserved.
//

#import <Foundation/Foundation.h>

#import "APIClient.h"
#import "ServiceBase.h"
#import "{{_tbi_.entityName}}Proto.pb.h"
#import "PB{{_tbi_.entityName}}Mapper.h"

@interface {{_tbi_.entityName}}Service : ServiceBase

#pragma mark - Query/Find

// 读取最新的
+(void)findLatest:(long)cursorId withCallback:(APIResponseBlock)block;

// 读取更多的(page从2开始)
+(void)findMore:(int)page cursorId:(long)cursorId withCallback:(APIResponseBlock)block;

// 主键查找
+(void)findBy:(long)itemId withRef:(BOOL)withRef withCallback:(APIResponseBlock*)block;

// 从服务器读取
+(void)loadBy:(long)itemId withCallback:(APIResponseBlock*)block;

#pragma mark - Create

// 新建
+(void)create:(PB{{_tbi_.entityName}}*)item withCallback:(APIResponseBlock)block;
// 更新
+(void)save:(PB{{_tbi_.entityName}}*)item withCallback:(APIResponseBlock)block;

#pragma mark - Remove

// 删除
+(void)remove:(PB{{_tbi_.entityName}}*)item withCallback:(APIResponseBlock)block;


@end
