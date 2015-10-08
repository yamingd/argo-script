package com.{{prj._company_}}.{{prj._project_}}.convertor.{{_module_}};

import com.google.protobuf.ByteString;
import com.google.protobuf.InvalidProtocolBufferException;

import com.google.common.collect.Lists;
import java.util.List;

import com.argo.db.Values;

import com.{{prj._company_}}.{{prj._project_}}.ConvertorBase
import com.{{prj._company_}}.{{prj._project_}}.model.{{_module_}}.{{_tbi_.entityName}};
import com.{{prj._company_}}.{{prj._project_}}.protobuf.{{_module_}}.P{{_tbi_.entityName}};

{% for col in _tbi_.refs %}
import com.{{prj._company_}}.{{prj._project_}}.model.{{emm[col.ref_obj.name]}}.{{col.ref_obj.entityName}};
import com.{{prj._company_}}.{{prj._project_}}.protobuf.{{emm[col.ref_obj.name]}}.P{{col.ref_obj.entityName}};
import com.{{prj._company_}}.{{prj._project_}}.convertor.{{emm[col.ref_obj.name]}}.{{col.ref_obj.entityName}}Convertor;
{% endfor %}

public class {{_tbi_.entityName}}Convertor extends ConvertorBase{

    public static List<P{{_tbi_.entityName}}> toPB(List<{{_tbi_.entityName}}> items){
    	List<P{{_tbi_.entityName}}> list = Lists.newArrayList();
        for ({{_tbi_.entityName}} item : items){
            if (item != null) {
                list.add(toPB(item));
            }
        }
        return list;
    }

    public static List<{{_tbi_.entityName}}> fromPB(List<P{{_tbi_.entityName}}> items){
    	List<{{_tbi_.entityName}}> list = Lists.newArrayList();
        for (P{{_tbi_.entityName}} item : items){
            if (item != null) {
                list.add(fromPB(item));
            }
        }
        return list;
    }
	
	public static P{{_tbi_.entityName}} toPB({{_tbi_.entityName}} item){
	    P{{_tbi_.entityName}}.Builder builder = P{{_tbi_.entityName}}.newBuilder();
{% for col in _tbi_.columns %}
		if(null != item.get{{col.capName}}()){
	    	builder.set{{col.capName}}(item.get{{col.capName}}(){{col.protobuf_value}});
	    }
{% endfor %}

{% for col in _tbi_.refs %}

        {{col.ref_javatype}} {{col.ref_varName}} = item.get{{ col.ref_varName.capitalize() }}();
{% if col.ref_type == 'optional' %}
        if(null != {{col.ref_varName}}){
             build.set{{col.ref_varName.capitalize()}}({{col.ref_obj.entityName}}Convertor.toPB({{col.ref_varName}}));
        }
{% else %}
		if(null != {{col.ref_varName}}){
             build.setAll{{col.ref_varName.capitalize()}}({{col.ref_obj.entityName}}Convertor.toPB({{col.ref_varName}}));
        }
{% endif %}

{% endfor %}

		return builder.build();
	}

	public static {{_tbi_.entityName}} fromPB(P{{_tbi_.entityName}} pb){
	    {{_tbi_.entityName}} item = new {{_tbi_.entityName}}();

{% for col in _tbi_.columns %}
		if(pb.has{{col.capName}}()){
			{{col.java_type}} {{col.name}} = Values.get(pb.get{{col.capName}}(), {{col.java_type}}.class);
	    	item.set{{col.capName}}({{col.name}});
	    }
{% endfor %}

		return item;
	}

	public static {{_tbi_.entityName}} fromPB(ByteString byteString) throws InvalidProtocolBufferException {
		P{{_tbi_.entityName}} pb = P{{_tbi_.entityName}}.parseFrom(byteString);
		return fromPB(pb);
	}

}