{%- from "pxe/map.jinja" import pxe with context %}

{%- for f in pxe.get('files', []) %}
  {%- if f.source_dir is defined %}
{{pxe.root_dir|path_join('files', f.path)}}:
  f.recurse:
    - source: {{f.source_dir}}
    - user: {{pxe.user}}
    - group: {{pxe.group}}
    - dir_mode: 755
    - f_mode: 644
    - makedirs: True
    - template: jinja
    - defaults: {{ f.get('settings', {}) }}
  {%- elif f.source is defined %}
{{pxe.root_dir|path_join('files', f.path)}}:
  f.managed:
    - source: {{f.source}}
    {%- if f.source_hash is defined %}
    - source_hash: {{ f.source_hash }}
    {%- endif %}
    - user: {{pxe.user}}
    - group: {{pxe.group}}
    - mode: 644
    - makedirs: True
    - template: jinja
    - defaults: {{ f.get('settings', {}) }}
  {%- endif %}
{%- endfor %}