//
//  {{_tbi_.pb.name}}Service.m
//  com.{{prj._company_}}.{{prj._name_}}
//
//  Created by {{_user_}} on {{_now_}}.
//  Copyright (c). All rights reserved.
//

#import "{{_tbi_.pb.name}}Service.h"

@implementation {{_tbi_.pb.name}}Service

#pragma mark - Query/Find

+(void)findLatest:(long)cursorId withCallback:(APIResponseBlock)block{
    NSArray* list = [[{{_tbi_.pb.name}}Mapper instance] selectLimit:@"findLatest" where:@"{{ _tbi_.pk.name}} > ?" order:@"{{ _tbi_.pk.name }} desc" withArgs:@[@(cursorId), @(kListPageSize), @(0)] withRef:YES];
    if (list.count > 0) {
        block(list, nil, YES);
        if (list.count == kListPageSize) {
            return;
        }
    }
    
    NSString* url = [NSString stringWithFormat:@"/m/{{_tbi_.mvc_url()}}/1/%ld", cursorId];
    [[APIClient shared] getPath:url params:nil withCallback:^(PAppResponse* response, NSError *error) {
        if (error) {
            block(nil, error, NO);
        }else{
            NSArray* items = [APIClient dataToClass:response.data type:[{{_tbi_.pb.name}} class]];
            if (items.count > 0) {
                [[{{_tbi_.pb.name}}Mapper instance] save:@"findLatest" withList:items withRef:YES];
            }
            block(items, error, NO);
        }
    }];
}

// 读取更多的(page从2开始)
+(void)findMore:(int)page cursorId:(long)cursorId withCallback:(APIResponseBlock)block{
    
    NSArray* list = [[{{_tbi_.pb.name}}Mapper instance] selectLimit:@"findMore" where:@"{{ _tbi_.pk.name }} < ?" order:@"{{ _tbi_.pk.name }} desc" withArgs:@[@(cursorId), @(kListPageSize), @(0)] withRef:YES];
    if (list.count > 0) {
        block(list, nil, YES);
        if (list.count == kListPageSize) {
            return;
        }
    }
    
    NSString* url = [NSString stringWithFormat:@"/m/{{_tbi_.mvc_url()}}/%d/%ld", page, cursorId];
    [[APIClient shared] getPath:url params:nil withCallback:^(PAppResponse* response, NSError *error) {
        if (error) {
            block(nil, error, NO);
        }else{
            NSArray* items = [APIClient dataToClass:response.data type:[{{_tbi_.pb.name}} class]];
            if (items.count > 0) {
                [[{{_tbi_.pb.name}}Mapper instance] save:@"findMore" withList:items withRef:YES];
            }
            block(items, error, NO);
        }
    }];
}

// 主键查找
+(void)findBy:({{ _tbi_.pk.ios.typeName }})itemId withRef:(BOOL)withRef withCallback:(APIResponseBlock)block{
    //1. 从本地读
    {{_tbi_.pb.name}}* item = [[{{_tbi_.pb.name}}Mapper instance] get:@(itemId) withRef:withRef];
    if (item) {
        block(item, nil, YES);
        return;
    }
    
    [self loadBy:itemId withCallback:block];
}

// 从服务器读取
+(void)loadBy:( {{ _tbi_.pk.ios.typeName }})itemId withCallback:(APIResponseBlock)block{
    
    //2. 从服务器读
    NSString* url = [NSString stringWithFormat:@"/m/{{_tbi_.mvc_url()}}/%ld", itemId];
    [[APIClient shared] getPath:url params:nil withCallback:^(PAppResponse* response, NSError *error) {
        if (error) {
            block(nil, error, NO);
        }else{
            NSArray* items = [APIClient dataToClass:response.data type:[{{_tbi_.pb.name}} class]];
            {{_tbi_.pb.name}}* item = nil;
            if (items.count > 0) {
                item = items.firstObject;
                [[{{_tbi_.pb.name}}Mapper instance] save:@"findBy" withItem:item withRef:YES];
            }
            block(item, error, NO);
        }
    }];
    
}

#pragma mark - Create

// 新建
+(void)create:({{_tbi_.pb.name}}*)item withCallback:(APIResponseBlock)block{
    
    //1. 写入服务器，并返回
    NSString* url = @"/m/{{_tbi_.mvc_url()}}/";
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    //TODO: 构造参数
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

+(void)parseCreateReponse:(PAppResponse*)response error:(NSError*)error withCallback:(APIResponseBlock)block{
    if (error) {
        block(nil, error, NO);
    }else{
        NSArray* items = [APIClient dataToClass:response.data type:[{{_tbi_.pb.name}} class]];
        {{_tbi_.pb.name}}* item = nil;
        if (items.count > 0) {
            item = items.firstObject;
            [[{{_tbi_.pb.name}}Mapper instance] save:@"save" withItem:item withRef:YES];
        }
        block(item, error, NO);
    }
}

// 更新
+(void)save:({{_tbi_.pb.name}}*)item withCallback:(APIResponseBlock)block{
    
    //1. 写入服务器，并返回
    NSString* url = [NSString stringWithFormat:@"/m/{{_tbi_.mvc_url()}}/%ld", item.id];
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    //TODO: 构造参数
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
+(void)remove:({{_tbi_.pb.name}}*)item withCallback:(APIResponseBlock)block{
    
    //1. 写入服务器，并返回
    NSString* url = [NSString stringWithFormat:@"/m/{{_tbi_.mvc_url()}}/%ld", item.id];
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [[APIClient shared] deletePath:url params:params withCallback:^(PAppResponse* response, NSError *error) {
        if (error) {
            block(nil, error, NO);
        }else{
            if (response.code == 200) {
                [[{{_tbi_.pb.name}}Mapper instance] removeBy:@(item.id)];
            }
            block(response, error, NO);
        }
    }];
}


@end
