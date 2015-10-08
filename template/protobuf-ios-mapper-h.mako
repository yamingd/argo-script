//
//  PB{{_tbi_.entityName}}Mapper.h
//  {{prj._project_}}
//
//  Created by {{_user_}} on {{_now_}}.
//  Copyright © 2015 {{prj._company_}}. All rights reserved.
//

#import "iOSBootstrap/SqliteMapper.h"
#import "PB{{_tbi_.entityName}}.pb.h"

{% for c in _refms_ %}
@class PB{{c.ref_obj.entityName}}Mapper; 
{% endfor %}

@interface PB{{_tbi_.entityName}}Mapper : SqliteMapper

+(instancetype)instance;

#pragma mark - Wrap
{% for c in _tbi_.refs %}
-(void)wrap{{c.ref_varName.capitalize()}}:(PB{{_tbi_.entityName}}Builder*)builder;
{% endfor %} 

{% for c in _tbi_.refs %}
-(void)wrap{{c.ref_varName.capitalize()}}List:(NSArray*)builders;
{% endfor %}


@end
