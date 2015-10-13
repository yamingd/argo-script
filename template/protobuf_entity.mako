{% for col in _refms_ %}
import "PB{{col}}Proto.proto";
{% endfor %}

package {{emm[_tbi_.name]}};
option java_package = "com.{{prj._company_}}.{{prj._project_}}.protobuf.{{_module_}}";
option java_multiple_files = true;

message PB{{_tbi_.entityName}} {
{% for col in _tbi_.columns %}
	// {{col.comment}}
    optional {{col.protobuf_type}} {{col.name}} = {{ col.index + 1}};
{% endfor %}

{% set count = _tbi_.columns | length %}
{% for col in _tbi_.refs %}
    {{col.ref_type}} {{col.ref_obj.refPrefix(_tbi_, emm)}}PB{{col.ref_obj.entityName}} {{col.ref_varName}} = {{ count + 1}};
{% set count = count +1 %}
{% endfor %}

}
