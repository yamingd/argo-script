//
//  {{_tbi_.pb.name}}Mapper.m
//  {{prj._project_}}
//
//  Created by {{_user_}}.
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
    self.pkColumn = @"{{_tbi_.pk.pb.name}}";
    self.tableName = @"{{_tbi_.pb.name}}";
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
-(void)wrap{{r.pb.nameC}}:({{_tbi_.pb.name}}Builder*)builder{
{% if r.repeated %}
    {{ r.column.ios.typeRef }} val = builder.{{r.column.pb.name}};
    if(val){
       NSArray* items = [[{{ r.pb.typeName }}Mapper instance] gets:@"wrap{{ r.pb.nameC }}" withComma:val withRef:YES];
       [builder set{{ r.pb.nameC }}Array:items];
    }
{% else %}
    {{ r.column.ios.typeRef }} val = builder.{{r.column.pb.name}};
{% if not r.column.ios.pointer %}
    if (val <= 0){
        return;
    }
    id item = [[{{ r.pb.typeName }}Mapper instance] get:@(val) withRef:YES];
{% else %}
    id item = [[{{ r.pb.typeName }}Mapper instance] get:val withRef:YES];
{% endif %}
    [builder set{{ r.pb.nameC }}:item];
{% endif %}
}
{% endfor %} 

-(id)wrap:(id)item withRef:(BOOL)ref{
    if(!item){
       return item;
    }
{% if _tbi_.refFields %}
    {{_tbi_.pb.name}}Builder* builder = [{{_tbi_.pb.name}} builderWithPrototype:item];
{% for r in _tbi_.refFields %}
    //
    [self wrap{{ r.pb.nameC }}:builder];
{% endfor %}    

    item = [builder build];
{% endif %}
    return item;
}

{% for r in _tbi_.refFields %}
-(void)wrap{{r.pb.nameC}}List:(NSArray*)builders{
{% if r.repeated %}
    for({{_tbi_.pb.name}}Builder* builder in builders){
        {{ r.column.ios.typeRef }} val = builder.{{r.column.pb.name}};
        if(val){
           NSArray* items = [[{{ r.pb.typeName }}Mapper instance] gets:@"wrap{{ r.pb.nameC }}List" withComma:val withRef:YES];
           [builder set{{ r.pb.nameC }}Array:items];
        }
    }
{% else %}
    NSMutableSet* vals = [NSMutableSet set];
    for({{ _tbi_.pb.name }}Builder* builder in builders){
        {{ r.column.ios.typeRef }} val = builder.{{r.column.pb.name}};
{% if not r.column.ios.pointer %}
        if (val <= 0){
            continue;
        }
        [vals addObject:@(val)];
{% else %}
        if(val){
            [vals addObject:val];
        }
{% endif %}
        
    }
    NSArray* items = [[{{ r.pb.typeName }}Mapper instance] gets:@"wrap{{ r.pb.nameC }}List" withSet:vals withRef:YES];
    for({{ r.pb.typeName }}* item in items){
        id val0 = @(item.{{ r.table.pk.pb.name }});
        for({{_tbi_.pb.name}}Builder* builder in builders){
            id val1 = {{r.column.ios.valExp("builder")}};
            if(val1 && [val0 isEqual:val1]){
                [builder set{{r.pb.nameC}}:item];
            }
        }
    }
{% endif %}
}
{% endfor %} 

-(id)wrapList:(NSArray*)items withRef:(BOOL)ref{
    if(!items || items.count == 0){
        return items;
    }
{% if _tbi_.refFields %}
    NSMutableArray* builders = [NSMutableArray array];
    for({{_tbi_.pb.name}}* item in items){
        {{_tbi_.pb.name}}Builder* builder = [{{_tbi_.pb.name}} builderWithPrototype:item];
        [builders addObject:builder];
    }
{% for r in _tbi_.refFields %}
    //
    [self wrap{{ r.pb.nameC }}List:builders];
{% endfor %}    

   
    NSMutableArray* result = [NSMutableArray array];
    for ({{_tbi_.pb.name}}Builder* builder in builders) {
        [result addObject:[builder build]];
    }
    return result;
{% else %}
    return items;
{% endif %}

}

-(void)saveRef:(id)item{
{% if _tbi_.refFields %}
    {{_tbi_.pb.name}}* pb = ({{_tbi_.pb.name}}*)item;
{% for r in _tbi_.refFields %}
    // 保存 {{r.pb.nameC}}
    id {{r.pb.name}} =  pb.{{r.pb.name}};
    if ({{r.pb.name}}){
{% if r.repeated %}
        [[{{ r.pb.typeName }}Mapper instance] save:@"{{_tbi_.pb.name}}SaveRef" withList:{{r.pb.name}} withRef:YES];
{% else %}
        [[{{ r.pb.typeName }}Mapper instance] save:@"{{_tbi_.pb.name}}SaveRef" withItem:{{r.pb.name}} withRef:YES];
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
    // 保存 {{r.pb.nameC}}
    for({{_tbi_.pb.name}}* pb in items){
        id {{r.pb.name}} =  pb.{{r.pb.name}};
        if ({{r.pb.name}}){
{% if r.repeated %}
            [vals addObjectsFromArray:{{r.pb.name}}];
{% else %}
            [vals addObject:{{r.pb.name}}];
{% endif %}
        }
    }
    [[{{ r.pb.typeName }}Mapper instance] save:@"{{_tbi_.pb.name}}SaveRefList" withList:vals withRef:YES];
    [vals removeAllObjects];

{% endfor %}
{% endif %}
}

@end
