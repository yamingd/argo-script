//
//  TSServiceBase.m
//  k12
//
//  Created by Yaming on 11/5/14.
//  Copyright (c) 2014 jiaxiaobang.com. All rights reserved.
//

#import "ServiceBase.h"

@implementation ServiceBase

+ (void)postNotice:(NSString *)name userInfo:(NSDictionary *)userInfo{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil userInfo:userInfo];
    });
}

@end
