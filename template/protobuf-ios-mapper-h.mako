//
//  {{_tbi_.pb.name}}Mapper.h
//  {{prj._project_}}
//
//  Created by {{_user_}}.
//  Copyright © 2015 {{prj._company_}}. All rights reserved.
//

#import "iOSBootstrap/SqliteMapper.h"
#import "{{_tbi_.pb.name}}Proto.pb.h"

{% for r in _tbi_.impPBs %}
@class {{r.name}}Mapper; 
{% endfor %}

@interface {{_tbi_.pb.name}}Mapper : SqliteMapper

+(instancetype)instance;

#pragma mark - Wrap

{% for r in _tbi_.refFields %}
-(void)wrap{{r.pb.nameC}}:({{_tbi_.pb.name}}Builder*)builder;
{% endfor %} 

{% for r in _tbi_.refFields %}
-(void)wrap{{r.pb.nameC}}List:(NSArray*)builders;
{% endfor %}


@end
