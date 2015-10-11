//
//  ServiceBase.h
//  _project_
//
//  Created by _user_ on 11/5/14.
//  Copyright (c) 2014 _company_. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceBase : NSObject

+ (void) postNotice:(NSString*)name userInfo:(NSDictionary*)userInfo;

@end
