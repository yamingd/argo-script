//
//  {{_tbi_.entityName}}Service.m
//  com.{{prj._company_}}.{{prj._name_}}
//
//  Created by {{_user_}} on {{_now_}}.
//  Copyright (c). All rights reserved.
//

#import "{{_tbi_.entityName}}Service.h"

@implementation {{_tbi_.entityName}}Service

#pragma mark - Query/Find

+(void)findLatest:(long)cursorId withCallback:(APIResponseBlock)block{
    NSArray* list = [[PB{{_tbi_.entityName}}Mapper instance] selectLimit:@"findLatest" where:@"id > ?" order:@"id desc" withArgs:@[@(cursorId), kListPageSize, @(0)] withRef:YES];
    if (list.count > 0) {
        block(list, nil, YES);
        if (list.count == kListPageSize) {
            return;
        }
    }
    
    NSString* url = [NSString stringWithFormat:@"/{{_tbi_.mvc_url()}}/1/%ld", cursorId];
    [[APIClient shared] getPath:url params:nil withCallback:^(PAppResponse* response, NSError *error) {
        if (error) {
            block(nil, error, NO);
        }else{
            NSArray* items = [APIClient dataToClass:response.data type:[PB{{_tbi_.entityName}} class]];
            if (items.count > 0) {
                [[PB{{_tbi_.entityName}}Mapper instance] save:@"findLatest" withList:items withRef:YES];
            }
            block(items, error, NO);
        }
    }];
}

// 读取更多的(page从2开始)
+(void)findMore:(int)page cursorId:(long)cursorId withCallback:(APIResponseBlock)block{
    
    NSArray* list = [[PB{{_tbi_.entityName}}Mapper instance] selectLimit:@"findMore" where:@"id < ?" order:@"id desc" withArgs:@[@(cursorId), kListPageSize, @(0)] withRef:YES];
    if (list.count > 0) {
        block(list, nil, YES);
        if (list.count == kListPageSize) {
            return;
        }
    }
    
    NSString* url = [NSString stringWithFormat:@"/{{_tbi_.mvc_url()}}/%d/%ld", page, cursorId];
    [[APIClient shared] getPath:url params:nil withCallback:^(PAppResponse* response, NSError *error) {
        if (error) {
            block(nil, error, NO);
        }else{
            NSArray* items = [APIClient dataToClass:response.data type:[PB{{_tbi_.entityName}} class]];
            if (items.count > 0) {
                [[PB{{_tbi_.entityName}}Mapper instance] save:@"findMore" withList:items withRef:YES];
            }
            block(items, error, NO);
        }
    }];
}

// 主键查找
+(void)findBy:(long)itemId withRef:(BOOL)withRef withCallback:(APIResponseBlock*)block{
    //1. 从本地读
    PB{{_tbi_.entityName}}* item = [[PB{{_tbi_.entityName}}Mapper instance] get:itemId withRef:withRef];
    if (item) {
        block(item, nil, YES);
        return;
    }
    
    [self loadBy:itemId withCallback:block];
}

// 从服务器读取
+(void)loadBy:(long)itemId withCallback:(APIResponseBlock*)block{
    
    //2. 从服务器读
    NSString* url = [NSString stringWithFormat:@"/{{_tbi_.mvc_url()}}/%ld", itemId];
    [[APIClient shared] getPath:url params:nil withCallback:^(PAppResponse* response, NSError *error) {
        if (error) {
            block(nil, error, NO);
        }else{
            NSArray* items = [APIClient dataToClass:response.data type:[PB{{_tbi_.entityName}} class]];
            PB{{_tbi_.entityName}}* item = nil;
            if (items.count > 0) {
                item = items.firstObject;
                [[PB{{_tbi_.entityName}}Mapper instance] save:@"findBy" withItem:item withRef:YES];
            }
            block(item, error, NO);
        }
    }];
    
}

#pragma mark - Create

// 新建
+(void)create:(PB{{_tbi_.entityName}}*)item withCallback:(APIResponseBlock)block{
    
    //1. 写入服务器，并返回
    NSString* url = @"/{{_tbi_.mvc_url()}}/";
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    BOOL hasFile = NO;
    if (hasFile) {
        [[APIClient shared] postPath:url params:params formBody:^(id<AFMultipartFormData> formData) {
            
        } withCallback:^(id response, NSError *error) {
            [self parseCreateReponse:response error:error withCallback:block];
        }];
    }else{
        [[APIClient shared] postPath:url params:params formBody:nil withCallback:^(id response, NSError *error) {
            [self parseCreateReponse:response error:error withCallback:block];
        }];
    }
}

+(void)parseCreateReponse:(id)response error:(NSError*)error withCallback:(APIResponseBlock)block{
    if (error) {
        block(nil, error, NO);
    }else{
        NSArray* items = [APIClient dataToClass:response.data type:[PB{{_tbi_.entityName}} class]];
        PB{{_tbi_.entityName}}* item = nil;
        if (items.count > 0) {
            item = items.firstObject;
            [[PB{{_tbi_.entityName}}Mapper instance] save:@"save" withItem:item withRef:YES];
        }
        block(item, error, NO);
    }
}

// 更新
+(void)save:(PB{{_tbi_.entityName}}*)item withCallback:(APIResponseBlock)block{
    
    //1. 写入服务器，并返回
    NSString* url = [NSString stringWithFormat:@"/{{_tbi_.mvc_url()}}/%ld", item.id];
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    BOOL hasFile = NO;
    if (hasFile) {
        [[APIClient shared] postPath:url params:params formBody:^(id<AFMultipartFormData> formData) {
            
        } withCallback:^(PAppResponse* response, NSError *error) {
            [self parseCreateReponse:response error:error withCallback:block];
        }];
    }else{
        [[APIClient shared] putPath:url params:params withCallback:^(PAppResponse* response, NSError *error) {
            [self parseCreateReponse:response error:error withCallback:block];
        }];
    }
}

#pragma mark - Remove

// 删除
+(void)remove:(PB{{_tbi_.entityName}}*)item withCallback:(APIResponseBlock)block{
    
    //1. 写入服务器，并返回
    NSString* url = [NSString stringWithFormat:@"/{{_tbi_.mvc_url()}}/%ld", item.id];
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [[APIClient shared] deletePath:url params:params withCallback:^(PAppResponse* response, NSError *error) {
        if (error) {
            block(nil, error, NO);
        }else{
            if (response.code == 200) {
                [[PB{{_tbi_.entityName}}Mapper instance] removeBy:item.id];
            }
            block(response, error, NO);
        }
    }];
}


@end
