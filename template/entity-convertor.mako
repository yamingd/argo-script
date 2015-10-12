package com.{{prj._company_}}.{{prj._project_}}.convertor.{{_module_}};

import com.google.protobuf.ByteString;
import com.google.protobuf.InvalidProtocolBufferException;

import com.google.common.collect.Lists;
import java.util.List;
import java.util.Date;

import com.argo.db.Values;

import com.{{prj._company_}}.{{prj._project_}}.ConvertorBase;
import com.{{prj._company_}}.{{prj._project_}}.model.{{_module_}}.{{_tbi_.entityName}};
import com.{{prj._company_}}.{{prj._project_}}.protobuf.{{_module_}}.PB{{_tbi_.entityName}};

{% for col in _tbi_.refs %}
import com.{{prj._company_}}.{{prj._project_}}.model.{{emm[col.ref_obj.name]}}.{{col.ref_obj.entityName}};
import com.{{prj._company_}}.{{prj._project_}}.protobuf.{{emm[col.ref_obj.name]}}.PB{{col.ref_obj.entityName}};
import com.{{prj._company_}}.{{prj._project_}}.convertor.{{emm[col.ref_obj.name]}}.{{col.ref_obj.entityName}}Convertor;
{% endfor %}

public class {{_tbi_.entityName}}Convertor extends ConvertorBase{

    public static List<PB{{_tbi_.entityName}}> toPB(List<{{_tbi_.entityName}}> items){
    	List<PB{{_tbi_.entityName}}> list = Lists.newArrayList();
        for ({{_tbi_.entityName}} item : items){
            if (item != null) {
                list.add(toPB(item));
            }
        }
        return list;
    }

    public static List<{{_tbi_.entityName}}> fromPB(List<PB{{_tbi_.entityName}}> items){
    	List<{{_tbi_.entityName}}> list = Lists.newArrayList();
        for (PB{{_tbi_.entityName}} item : items){
            if (item != null) {
                list.add(fromPB(item));
            }
        }
        return list;
    }
	
	public static PB{{_tbi_.entityName}} toPB({{_tbi_.entityName}} item){
	    PB{{_tbi_.entityName}}.Builder builder = PB{{_tbi_.entityName}}.newBuilder();
{% for col in _tbi_.columns %}
		if(null != item.get{{col.capName}}()){
	    	builder.set{{col.capName}}({{col.protobuf_value}});
	    }
{% endfor %}

{% for col in _tbi_.refs %}

        {{col.ref_javatype}} {{col.ref_varName}} = item.get{{ col.ref_varName.capitalize() }}();
{% if col.ref_type == 'optional' %}
        if(null != {{col.ref_varName}}){
             builder.set{{col.ref_varNameC}}({{col.ref_obj.entityName}}Convertor.toPB({{col.ref_varName}}));
        }
{% else %}
		if(null != {{col.ref_varName}}){
             builder.addAll{{col.ref_varNameC}}({{col.ref_obj.entityName}}Convertor.toPB({{col.ref_varName}}));
        }
{% endif %}

{% endfor %}

		return builder.build();
	}

	public static {{_tbi_.entityName}} fromPB(PB{{_tbi_.entityName}} pb){
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
		PB{{_tbi_.entityName}} pb = PB{{_tbi_.entityName}}.parseFrom(byteString);
		return fromPB(pb);
	}

}