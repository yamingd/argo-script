{% for r in _tbi_.impPBs %}
import "{{ r.name }}Proto.proto";
{% endfor %}

package {{_tbi_.package}};
option java_package = "com.{{prj._company_}}.{{prj._project_}}.protobuf.{{_module_}}";
option java_multiple_files = true;

message {{_tbi_.pb.name}} {
{% for col in _tbi_.columns %}
	// {{col.comment}}
    optional {{col.pb.typeName}} {{col.name}} = {{ col.index + 1}};
{% endfor %}

{% set count = _tbi_.columns | length %}
{% for r in _tbi_.refFields %}
    {{ r.pb.mark }} {{ r.pb.package }}{{ r.pb.typeName }} {{ r.pb.name }} = {{ count + 1}};
{% set count = count +1 %}
{% endfor %}

}
