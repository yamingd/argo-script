//
// TS{{_tbi_.entityName}}.hh
// com.{{prj._company_}}.{{prj._name_}}
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>
#import "PBObjcWrapper.hh"
{% for col in _tbi_.refImport() %}
#import "TS{{col}}.hh"
{% endfor %}

@interface TS{{_tbi_.entityName}} : RLMObject<PBObjcWrapper>

{% for col in _tbi_.columns %}
// {{col.comment}}
@property {{col.ios.typeRef}} {{col.name}};

{% endfor %}

{% for col in _tbi_.refs %}
@property {{col.ref_obj.protobufRefAs(col.ref_type)}} {{col.ref_varName}};
{% endfor %}

@end

RLM_ARRAY_TYPE(TS{{_tbi_.entityName}})