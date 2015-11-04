package com.{{prj._company_}}.{{prj._project_}}.convertor.{{_module_}};

import com.google.protobuf.ByteString;
import com.google.protobuf.InvalidProtocolBufferException;

import com.google.common.collect.Lists;
import java.util.List;
import java.util.Date;

import com.argo.db.Values;

import com.{{prj._company_}}.{{prj._project_}}.ConvertorBase;
import com.{{prj._company_}}.{{prj._project_}}.model.{{_module_}}.{{_tbi_.java.name}};
import com.{{prj._company_}}.{{prj._project_}}.protobuf.{{_module_}}.PB{{_tbi_.java.name}};

{% for r in _tbi_.impJavas %}
import com.{{prj._company_}}.{{prj._project_}}.model.{{r.package}}.{{r.name}};
import com.{{prj._company_}}.{{prj._project_}}.protobuf.{{r.package}}.PB{{r.name}};
import com.{{prj._company_}}.{{prj._project_}}.convertor.{{r.package}}.{{r.name}}Convertor;

{% endfor %}

public class {{_tbi_.java.name}}Convertor extends ConvertorBase{

    /**
     * 转换为Protobuf对象
     */
    public static List<PB{{_tbi_.java.name}}> toPB(List<{{_tbi_.java.name}}> items){
    	List<PB{{_tbi_.java.name}}> list = Lists.newArrayList();
        for ({{_tbi_.java.name}} item : items){
            if (item != null) {
                list.add(toPB(item));
            }
        }
        return list;
    }

    /**
     * 转换为数据库实体对象
     */
    public static List<{{_tbi_.java.name}}> fromPB(List<PB{{_tbi_.java.name}}> items){
    	List<{{_tbi_.java.name}}> list = Lists.newArrayList();
        for (PB{{_tbi_.java.name}} item : items){
            if (item != null) {
                list.add(fromPB(item));
            }
        }
        return list;
    }
	
    /**
     * 转换为Protobuf对象
     */
	public static PB{{_tbi_.java.name}} toPB({{_tbi_.java.name}} item){
	    PB{{_tbi_.java.name}}.Builder builder = PB{{_tbi_.java.name}}.newBuilder();
{% for col in _tbi_.columns %}
		if(null != item.get{{col.java.getterName}}()){
	    	builder.set{{col.java.setterName}}({{col.java.pbValue}});
	    }
{% endfor %}

{% for r in _tbi_.refFields %}

        {{r.java.typeName}} {{r.java.name}} = item.get{{ r.java.getterName }}();
{% if not r.repeated %}
        if(null != {{r.java.name}}){
             builder.set{{ r.java.setterName }}({{r.java.refJava.name}}Convertor.toPB({{r.java.name}}));
        }
{% else %}
		if(null != {{r.java.name}}){
             builder.addAll{{ r.java.setterName }}({{ r.java.refJava.name }}Convertor.toPB({{ r.java.name }}));
        }
{% endif %}

{% endfor %}

		return builder.build();
	}

    /**
     * 转换为数据库实体对象
     */
	public static {{_tbi_.java.name}} fromPB(PB{{_tbi_.java.name}} pb){
	    {{_tbi_.java.name}} item = new {{_tbi_.java.name}}();

{% for col in _tbi_.columns %}
		if(pb.has{{col.java.setterName}}()){
			{{col.java.typeName}} {{col.java.name}} = Values.get(pb.get{{col.java.setterName}}(), {{col.java.typeName}}.class);
	    	item.set{{col.java.setterName}}({{col.java.name}});
	    }
{% endfor %}

		return item;
	}

    /**
     * 转换为数据库实体对象
     */
	public static {{_tbi_.java.name}} fromPB(ByteString byteString) throws InvalidProtocolBufferException {
		PB{{_tbi_.java.name}} pb = PB{{_tbi_.java.name}}.parseFrom(byteString);
		return fromPB(pb);
	}

}