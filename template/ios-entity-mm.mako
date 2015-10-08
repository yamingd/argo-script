//
// TS{{_tbi_.entityName}}.mm
// {{_project_}}
//

#import "TS{{_tbi_.entityName}}.hh"
#import "{{_module_}}/{{_tbi_.entityName}}Proto.pb.hh"
#import "PBObjc.hh"

@interface TS{{_tbi_.entityName}} ()

@property (nonatomic, strong)NSData* protocolData;

@end

@implementation TS{{_tbi_.entityName}}

-(instancetype) initWithProtocolData:(NSData*) data {
    return [self initWithData:data];
}
-(instancetype) initWithProtocolObj:(google::protobuf::Message*) pbmsg {
    // c++
    if(self = [super init]) {
        // c++
        {{_module_}}::P{{_tbi_.entityName}}* pbobj = ({{_module_}}::P{{_tbi_.entityName}}*)pbmsg;
        //
        [self initValues:pbobj];
    }
    //
    return self;
} 
-(NSData*) getProtocolData {
    return self.protocolData;
}
-(void)initValues:({{_module_}}::P{{_tbi_.entityName}}*) pbobj{
{% for col in _tbi_.columns %}
    if(pbobj->has_{{col.protobuf_name}}()){
        const {{col.cpp_type}} {{col.name}} = pbobj->{{col.protobuf_name}}();
        self.{{col.name}} = [PBObjc {{col.cpp_objc}}:{{col.name}}];
    }
{% endfor %}
    //
{% for col in _tbi_.refs %}
{% if col.ref_type == 'repeated' %}
    for(int i=0; i<pbobj->{{col.ref_varName}}_size();i++){
        {{emm[col.ref_obj.name]}}::P{{col.ref_obj.entityName}}* pbref = pbobj->mutable_{{col.ref_varName | lower}}(i);
        [self.{{col.ref_varName}} addObject:[[TS{{col.ref_obj.entityName}} alloc] initWithProtocolObj: pbref]];
    }
{% else %}
    if(pbobj->has_{{col.ref_varName | lower}}()){
        {{emm[col.ref_obj.name]}}::P{{col.ref_obj.entityName}}* pbref = pbobj->mutable_{{col.ref_varName | lower}}();
        self.{{col.ref_varName}} = [[TS{{col.ref_obj.entityName}} alloc] initWithProtocolObj: pbref];
    }
{% endif %}
{% endfor %}
}
-(instancetype) initWithData:(NSData*) data {
    
    if(self = [super init]) {
        // c++
        {{_module_}}::P{{_tbi_.entityName}}* pbmsg = [self deserialize:data];
        //
        [self initValues:pbmsg];
        // c++->objective C
        self.protocolData = data;
    }
    return self;
}

-(NSMutableDictionary*)asDict{
    NSMutableDictionary* ret = [[NSMutableDictionary alloc] init];
    return ret;
}

{% if _tbi_.pkCol %}
+ (NSString*)primaryKey{
    return @"{{_tbi_.pkCol.name}}";
}
{% endif %}
+ (NSArray*)ignoredProperties{
    return @[@"protocolData"];
}

#pragma mark private
 
-(const std::string) serializedProtocolBufferAsString {
    {{_module_}}::P{{_tbi_.entityName}} *pmsg = new {{_module_}}::P{{_tbi_.entityName}};
    // objective c->c++
    // 
    {% for col in _tbi_.columns %}
    const {{col.cpp_type}} {{col.name}} = [PBObjc {{col.objc_cpp}}:self.{{col.name}}];
    {% endfor %}

    // c++->protocol buffer
    {% for col in _tbi_.columns %}
    pmsg->set_{{col.protobuf_name}}({{col.name}});
    {% endfor %}
    
    std::string ps = pmsg->SerializeAsString();
    return ps;
}
 
#pragma mark private methods
- ({{_module_}}::P{{_tbi_.entityName}} *)deserialize:(NSData *)data {
    int len = [data length];
    char raw[len];
    {{_module_}}::P{{_tbi_.entityName}} *resp = new {{_module_}}::P{{_tbi_.entityName}};
    [data getBytes:raw length:len];
    resp->ParseFromArray(raw, len);
    return resp;
}

@end