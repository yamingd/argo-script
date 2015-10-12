ms:
{% for m in _modules_ %}
{% for tb in m['tables'] %}
   {{tb.name}}: {{m['ns']}}
{% endfor %}

{% endfor %}