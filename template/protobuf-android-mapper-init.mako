package com.{{prj._company_}}.{{prj._project_}}.mapper;

{% for minfo in prj._modules_ %}
{% for t in minfo['tables'] %}
import com.{{prj._company_}}.{{prj._project_}}.mapper.{{minfo['ns']}}.PB{{t.entityName}}Mapper;
{% endfor %}
{% endfor %}

public final class PBMapperInit {

{% for minfo in prj._modules_ %}
{% for t in minfo['tables'] %}
  public static PB{{t.entityName}}Mapper {{t.varName}}Mapper;
{% endfor %}
{% endfor %}

  static {

{% for minfo in prj._modules_ %}
{% for t in minfo['tables'] %}
  {{t.varName}}Mapper = new PB{{t.entityName}}Mapper();
{% endfor %}
{% endfor %}

  }

  public static void prepare() {
{% for minfo in prj._modules_ %}
{% for t in minfo['tables'] %}
  {{t.varName}}Mapper.prepare();
{% endfor %}
{% endfor %}
  }

  public static void reset() {
{% for minfo in prj._modules_ %}
{% for t in minfo['tables'] %}
  {{t.varName}}Mapper.resetStatement();
{% endfor %}
{% endfor %}
  }
}
