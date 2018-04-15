{%- from "pxe/map.jinja" import pxe with context %}

{%- for f in pxe.get('files', []) %}
  {%- if f.type|lower == 'directory' %}
{{pxe.root_dir|path_join(f.path)}}:
  file.recurse:
    - source: {{f.source}}
    - user: {{pxe.user}}
    - group: {{pxe.group}}
    - dir_mode: 755
    - f_mode: 644
    - makedirs: True
    - template: jinja
    - defaults: {{ f.get('settings', {}) }}
  {%- elif f.type|lower == 'file' %}
{{pxe.root_dir|path_join(f.path)}}:
  file.managed:
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
  {%- elif f.type|lower == 'symlink' %}
{{pxe.root_dir|path_join(f.path)}}:
  file.symlink:
    - name: {{f.name}}
    - target: {{f.target}}
    - user: {{pxe.user}}
    - group: {{pxe.group}}
    - mode: 644
    - makedirs: True
  {%- endif %}
{%- endfor %}