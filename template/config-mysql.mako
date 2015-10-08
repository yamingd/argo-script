printsql: true

ms:
{% for m in _modules_ %}
   - name: {{m['ns']}}
     master: 
       - {{m['dburl']}}/{{m['db']}}
     slave: 
       - {{m['dburl']}}/{{m['db']}}
{% endfor %}