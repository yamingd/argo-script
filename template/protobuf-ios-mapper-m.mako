//
//  {{_tbi_.pb.name}}Mapper.m
//  {{prj._project_}}
//
//  Created by {{_user_}} on {{_now_}}.
//  Copyright © 2015 {{prj._company_}}. All rights reserved.
//

#import "{{_tbi_.pb.name}}Mapper.h"

{% for r in _tbi_.impPBs %}
#import "{{r.name}}Mapper.h" 
{% endfor %}

@implementation {{_tbi_.pb.name}}Mapper

+(instancetype)instance{
    static {{_tbi_.pb.name}}Mapper *_shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[{{_tbi_.pb.name}}Mapper alloc] init];
    });
    return _shared;
}

-(instancetype)init{
    self = [super init];
    return self;
}

-(void)prepare{
    self.pkColumn = @"{{_tbi_.pk.name}}";
    self.tableName = @"{{_tbi_.name}}";
    self.tableColumns = {{_tbi_.ios.columnsInfo()}};
    self.columns = @[{{", ".join(_tbi_.ios.columns())}}];
    
    [super prepare];
}

-(void)ensureContext{
    AppBootstrap *appDelegate = [[UIApplication sharedApplication] delegate];
    self.sqliteContext = appDelegate.sqliteContext;
}

#pragma mark - ResultSet

-(id)map:(FMResultSet*)rs withItem:(id)item{
    {{_tbi_.pb.name}}Builder* builder = [{{_tbi_.pb.name}} builder];
{% for c in _tbi_.columns %}
    [builder set{{c.java.setterName}}:[rs {{c.ios.rsGetter}}:{{c.index}}]];
{% endfor %}
    return [builder build];
}

#pragma mark - Save

-(NSArray*)buildSaveParameters:(id)item{
    //TODO: nil的判断
    {{_tbi_.pb.name}}* pb = ({{_tbi_.pb.name}}*)item;
    NSMutableArray* args = [NSMutableArray array];
{% for c in _tbi_.columns %}
    [args addObject:{{c.ios.valExp("pb")}}];
{% endfor %}    
    return args;
}

#pragma mark - Wrap
{% for r in _tbi_.refFields %}
-(void)wrap{{r.varNameC}}:({{_tbi_.pb.name}}Builder*)builder{
{% if r.repeated %}
    id val = {{r.column.ios.valExp("builder")}};
    if(val){
       NSArray* items = [[{{ r.pb.typeName }}Mapper instance] gets:@"wrap{{ r.varNameC }}" withComma:val withRef:YES];
       [builder set{{ r.varNameC }}Array:items];
    }
{% else %}
    id val = {{r.column.ios.valExp("builder")}};
    id item = [[{{ r.pb.typeName }}Mapper instance] get:val withRef:YES];
    [builder set{{ r.varNameC }}:item];
{% endif %}
}
{% endfor %} 

-(void)wrap:(id)item withRef:(BOOL)ref{
    if(!item){
       return;
    }
{% if _tbi_.refFields %}
    {{_tbi_.pb.name}}Builder* builder = [{{_tbi_.pb.name}} builderWithPrototype:item];
{% for r in _tbi_.refFields %}
    //
    [self wrap{{ r.varNameC }}:builder];
{% endfor %}    
{% endif %}

}

{% for r in _tbi_.refFields %}
-(void)wrap{{r.varNameC}}List:(NSArray*)builders{
{% if r.repeated %}
    for({{_tbi_.pb.name}}Builder* builder in builders){
        id val = {{r.column.ios.valExp("builder")}};
        if(val){
           NSArray* items = [[{{ r.pb.typeName }}Mapper instance] gets:@"wrap{{ r.varNameC }}" withComma:val withRef:YES];
           [builder set{{ r.varNameC }}Array:items];
        }
    }
{% else %}
    NSMutableSet* vals = [NSMutableSet set];
    for({{ _tbi_.pb.name }}Builder* builder in builders){
        id val = {{r.column.ios.valExp("builder")}};
        if(val){
            [vals addObject:val];
        }
    }
    NSArray* items = [[{{ r.pb.typeName }}Mapper instance] gets:@"wrap{{ r.varNameC }}List" withSet:vals withRef:YES];
    for({{ r.pb.typeName }}* item in items){
        id val0 = @(item.{{ r.table.pk.name }});
        for({{_tbi_.pb.name}}Builder* builder in builders){
            id val1 = {{r.column.ios.valExp("builder")}};
            if(val1 && [val0 isEqual:val1]){
                [builder set{{r.varNameC}}:item];
            }
        }
    }
{% endif %}
}
{% endfor %} 

-(void)wrapList:(NSArray*)items withRef:(BOOL)ref{
    if(!items || items.count == 0){
        return;
    }
{% if _tbi_.refFields %}
    NSMutableArray* builders = [NSMutableArray array];
    for({{_tbi_.pb.name}}* item in items){
        {{_tbi_.pb.name}}Builder* builder = [{{_tbi_.pb.name}} builderWithPrototype:item];
        [builders addObject:builder];
    }
{% for r in _tbi_.refFields %}
    //
    [self wrap{{ r.varNameC }}List:builders];
{% endfor %}    
{% endif %}

}

-(void)saveRef:(id)item{
{% if _tbi_.refFields %}
    {{_tbi_.pb.name}}* pb = ({{_tbi_.pb.name}}*)item;
{% for r in _tbi_.refFields %}
    // 保存 {{r.varName}}
    id {{r.varName}} =  pb.{{r.varName}};
    if ({{r.varName}}){
{% if r.repeated %}
        [[{{ r.pb.typeName }}Mapper instance] save:@"{{_tbi_.pb.name}}SaveRef" withList:{{r.varName}} withRef:YES];
{% else %}
        [[{{ r.pb.typeName }}Mapper instance] save:@"{{_tbi_.pb.name}}SaveRef" withItem:{{r.varName}} withRef:YES];
{% endif %}
    }

{% endfor %}
{% endif %}

}

-(void)saveRefList:(NSArray*)items{
    if(!items || items.count == 0){
        return;
    }
{% if _tbi_.refFields %}
    NSMutableArray* vals = [NSMutableArray array];
{% for r in _tbi_.refFields %}
    // 保存 {{r.varName}}
    for({{_tbi_.pb.name}}* pb in items){
        id {{r.varName}} =  pb.{{r.varName}};
        if ({{r.varName}}){
{% if r.repeated %}
            [vals addObjectsFromArray:{{r.varName}}];
{% else %}
            [vals addObject:{{r.varName}}];
{% endif %}
        }
    }
    [[{{ r.pb.typeName }}Mapper instance] save:@"{{_tbi_.pb.name}}SaveRefList" withList:vals withRef:YES];
    [vals removeAllObjects];

{% endfor %}
{% endif %}
}

@end
