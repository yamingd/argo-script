package {{ _tbi_.java.convertor_ns }};

import com.google.protobuf.ByteString;
import com.google.protobuf.InvalidProtocolBufferException;

import com.google.common.collect.Lists;
import java.util.List;
import java.util.Date;
{% if _tbi_.hasBigDecimal %}
import java.math.BigDecimal;
{% endif %}
import com.argo.db.Values;

import com.{{prj._company_}}.{{prj._project_}}.ConvertorBase;
import {{ _tbi_.java.model_ns }}.{{_tbi_.java.name}};
import {{ _tbi_.pb.model_ns }}.{{_tbi_.pb.name}};

{% for r in _tbi_.impJavas %}
import {{ r.model_ns }}.{{r.name}};
import {{ r.pb.model_ns }}.{{r.pb.name}};
import {{ r.convertor_ns }}.{{r.name}}Convertor;
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