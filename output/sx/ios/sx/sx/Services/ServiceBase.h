//
//  ServiceBase.h
//  sx
//
//  Created by yamingd on 11/5/14.
//  Copyright (c) 2014 aijia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceBase : NSObject

+ (void) postNotice:(NSString*)name userInfo:(NSDictionary*)userInfo;

@end
