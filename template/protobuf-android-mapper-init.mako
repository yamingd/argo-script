package com.{{prj._company_}}.{{prj._project_}}.mapper;

{% for minfo in prj._modules_ %}
{% for t in minfo['tables'] %}
import com.{{prj._company_}}.{{prj._project_}}.mapper.{{ t.package }}.{{t.pb.name}}Mapper;
{% endfor %}
{% endfor %}

public final class PBMapperInit {

{% for minfo in prj._modules_ %}
{% for t in minfo['tables'] %}
      public static {{t.pb.name}}Mapper {{t.pb.varName}}Mapper;
{% endfor %}
{% endfor %}

  static {

{% for minfo in prj._modules_ %}
{% for t in minfo['tables'] %}
      {{t.pb.varName}}Mapper = new {{t.pb.name}}Mapper();
{% endfor %}
{% endfor %}

  }

  public static void prepare() {
{% for minfo in prj._modules_ %}
{% for t in minfo['tables'] %}
      {{t.pb.varName}}Mapper.prepare();
{% endfor %}
{% endfor %}
  }

  public static void reset() {
{% for minfo in prj._modules_ %}
{% for t in minfo['tables'] %}
      {{t.pb.varName}}Mapper.resetStatement();
{% endfor %}
{% endfor %}
  }
}
