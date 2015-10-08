//
//  PB{{_tbi_.entityName}}Mapper.m
//  {{prj._project_}}
//
//  Created by {{_user_}} on {{_now_}}.
//  Copyright © 2015 {{prj._company_}}. All rights reserved.
//

#import "PB{{_tbi_.entityName}}Mapper.h"
#import "iOSBootstrap/AppBootstrap.h"

{% for c in _refms_ %}
#import "PB{{c.ref_obj.entityName}}Mapper.h" 
{% endfor %}

@implementation PB{{_tbi_.entityName}}Mapper

+(instancetype)instance{
    static PB{{_tbi_.entityName}}Mapper *_shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[PB{{_tbi_.entityName}}Mapper alloc] init];
    });
    return _shared;
}

-(instancetype)init{
    self = [super init];
    return self;
}

-(void)prepare{
    self.pkColumn = @"{{_tbi_.pkCol.name}}";
    self.tableName = @"{{_tbi_.name}}";
    self.tableColumns = {{_tbi_.ios.columnsInfo()}};
    self.columns = @[{{", ".join(_tbi_.ios.columns)}}];
    
    [super prepare];
}

-(void)ensureContext{
    AppBootstrap *appDelegate = [[UIApplication sharedApplication] delegate];
    self.sqliteContext = appDelegate.sqliteContext;
}

#pragma mark - ResultSet

-(id)map:(FMResultSet*)rs withItem:(id)item{
    PB{{_tbi_.entityName}}Builder builder = PB{{_tbi_.entityName}}.builder();
{% for c in _tbi_.columns %}
    [builder set{{c.capName}}:[rs {{c.ios.rsGetter}}:{{c.index}}]];
{% endfor %}
    return builder.build();
}

#pragma mark - Save

-(NSArray*)buildSaveParameters:(id)item{
    //TODO: nil的判断
    PB{{_tbi_.entityName}}* pb = (PB{{_tbi_.entityName}}*)item;
    NSMutableArray* args = [NSMutableArray array];
{% for c in _tbi_.columns %}
    [args addObject:{{c.ios.valExp("pb")}}];
{% endfor %}    
    return args;
}

#pragma mark - Wrap
{% for c in _tbi_.refs %}
-(void)wrap{{c.ref_varName.capitalize()}}:(PB{{_tbi_.entityName}}Builder*)builder{
{% if c.pbrepeated %}
    id val = {{c.ios.valExp("builder")}};
    if(val){
       NSArray* items = [[PB{{c.ref_obj.entityName}}Mapper instance] gets:@"wrap{{c.ref_varName.capitalize()}}" withComma:val withRef:YES];
       [builder set{{c.ref_varName.capitalize()}}Array:items];
    }
{% else %}
    id val = {{c.ios.valExp("builder")}};
    id item = [[PB{{c.ref_obj.entityName}}Mapper instance] get:val withRef:YES];
    [builder set{{c.ref_varName.capitalize()}}:item];
{% endif %}
}
{% endfor %} 

-(void)wrap:(id)item withRef:(BOOL)ref{
    if(!item){
       return;
    }
{% if _tbi_.refs %}
    PB{{_tbi_.entityName}}Builder* builder = [PB{{_tbi_.entityName}}Builder builderWithPrototype:item];
{% for c in _tbi_.refs %}
    //
    [self wrap{{c.ref_varName.capitalize()}}:builder];
{% endfor %}    
{% endif %}

}

{% for c in _tbi_.refs %}
-(void)wrap{{c.ref_varName.capitalize()}}List:(NSArray*)builders{
{% if c.pbrepeated %}
    for(PB{{_tbi_.entityName}}Builder* builder in builders){
        id val = {{c.ios.valExp("builder")}};
        if(val){
           NSArray* items = [[PB{{c.ref_obj.entityName}}Mapper instance] gets:@"wrap{{c.ref_varName.capitalize()}}" withComma:val withRef:YES];
           [builder set{{c.ref_varName.capitalize()}}Array:items];
        }
    }
{% else %}
    NSMutableSet* vals = [NSMutableSet array];
    for(PB{{_tbi_.entityName}}Builder* builder in builders){
        id val = {{c.ios.valExp("builder")}};
        [vals addObject:val];
    }
    NSArray* items = [[PB{{c.ref_obj.entityName}}Mapper instance] gets:@"wrap{{c.ref_varName.capitalize()}}List" withSet:vals withRef:YES];
    for(PB{{_tbi_.entityName}}* item in items){
        id val0 = {{c.ios.valExp("item")}};
        for(PB{{_tbi_.entityName}}Builder* builder in builders){
            id val1 = {{c.ios.valExp("builder")}};
            if([val0 isEqual:val1]){
                [builder set{{c.ref_varName.capitalize()}}:item];
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
{% if _tbi_.refs %}
    NSMutableArray* builders = [NSMutableArray array];
    for(PB{{_tbi_.entityName}}* items in items){
        PB{{_tbi_.entityName}}Builder* builder = [PB{{_tbi_.entityName}}Builder builderWithPrototype:item];
        [builders addObject:builder];
    }
{% for c in _tbi_.refs %}
    //
    [self wrap{{c.ref_varName.capitalize()}}List:builders];
{% endfor %}    
{% endif %}

}

-(void)saveRef:(id)item{
{% if _tbi_.refs %}
    PB{{_tbi_.entityName}}* pb = (PB{{_tbi_.entityName}}*)item;
{% for c in _tbi_.refs %}
    // 保存 {{c.ref_varName}}
    id {{c.ref_varName}} =  pb.{{c.ref_varName}};
    if ({{c.ref_varName}}){
    {% if c.pbrepeated %}
        [[PB{{c.ref_obj.entityName}}Mapper instance] save:@"{{_tbi_entityName}}SaveRef" withList:{{c.ref_varName}} withRef:YES];
    {% else %}
        [[PB{{c.ref_obj.entityName}}Mapper instance] save:@"{{_tbi_entityName}}SaveRef" withItem:{{c.ref_varName}} withRef:YES];
    {% endif %}
    }

{% endfor %}
{% endif %}

}

-(void)saveRefList:(NSArray*)items{
    if(!items || items.count == 0){
        return;
    }
{% if _tbi_.refs %}
    NSMutableArray* vals = [NSMutableArray array];
{% for c in _tbi_.refs %}
    // 保存 {{c.ref_varName}}
    for(PB{{_tbi_.entityName}}* pb in items){
        id {{c.ref_varName}} =  pb.{{c.ref_varName}};
        if ({{c.ref_varName}}){
    {% if c.pbrepeated %}
        [vals addObjectsFromArray:{{c.ref_varName}}];
    {% else %}
        [vals addObject:{{c.ref_varName}}];
    {% endif %}
    }
    }
    [[PB{{c.ref_obj.entityName}}Mapper instance] save:@"{{_tbi_entityName}}SaveRefList" withList:vals withRef:YES];
    [vals removeAllObjects];

{% endfor %}
{% endif %}
}

@end
