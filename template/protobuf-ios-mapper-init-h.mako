//
//  PBMapperInit.h
//  {{prj._project_}}
//
//  Created by {{_user_}} on {{_now_}}.
//  Copyright © 2015 {{prj._company_}}. All rights reserved.
//

{% for minfo in prj._modules_ %}

// {{minfo['ns']}}
{% for t in minfo['tables'] %}
@class PB{{t.entityName}}Mapper;
{% endfor %}
{% endfor %}

@interface PBMapperInit : NSObject

+(instancetype)instance;

-(void)start;

@end
