//
//  PBMapperInit.m
//  {{prj._project_}}
//
//  Created by {{_user_}} on {{_now_}}.
//  Copyright © 2015 {{prj._company_}}. All rights reserved.
//

#import "PBMapperInit.h"

{% for minfo in prj._modules_ %}

// {{minfo['ns']}}
{% for t in minfo['tables'] %}
#import "PB{{t.entityName}}Mapper.h"
{% endfor %}
{% endfor %}

@implementation PBMapperInit

+(instancetype)instance{
    static PBMapperInit *_shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[PBMapperInit alloc] init];
    });
    return _shared;
}

-(instancetype)init{
    self = [super init];
    return self;
}

-(void)start{

{% for minfo in prj._modules_ %}

	// {{minfo['ns']}}
{% for t in minfo['tables'] %}
	[[PB{{t.entityName}}Mapper instance] prepare];
{% endfor %}
{% endfor %}

}

@end
