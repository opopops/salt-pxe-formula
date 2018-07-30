{%- from "pxe/map.jinja" import pxe with context %}

{%- for f in pxe.get('files', []) %}
  {%- if f.type|lower == 'directory' %}
    {%- if f.get('source', False) %}
{{f.path}}_recurse:
  file.recurse:
    - name: {{pxe.root_dir|path_join(f.path)}}
    - source: {{f.source}}
    - user: {{f.get('user', pxe.user)}}
    - group: {{f.get('group', pxe.group)}}
    - dir_mode: {{f.get('dir_mode', 755)}}
    - file_mode: {{f.get('file_mode', 644)}}
    - makedirs: True
    - template: jinja
    - defaults: {{ f.get('settings', {}) }}
    - require_in:
      - file: {{f.path}}_directory
    {%- endif %}
{{f.path}}_directory:
  file.directory:
    - name: {{pxe.root_dir|path_join(f.path)}}
    - user: {{f.get('user', pxe.user)}}
    - group: {{f.get('group', pxe.group)}}
    - dir_mode: {{f.get('dir_mode', 755)}}
    - file_mode: {{f.get('file_mode', 644)}}
    - recurse:
      - user
      - group
      - mode
  {%- elif f.type|lower == 'file' %}
{{f.path}}:
  file.managed:
    - name: {{pxe.root_dir|path_join(f.path)}}
    - source: {{f.source}}
    {%- if f.source_hash is defined %}
    - source_hash: {{ f.source_hash }}
    {%- endif %}
    - user: {{f.get('user', pxe.user)}}
    - group: {{f.get('group', pxe.group)}}
    - mode: {{f.get('mode', 644)}}
    - makedirs: True
    - template: jinja
    - defaults: {{ f.get('settings', {}) }}
  {%- elif f.type|lower == 'symlink' %}
{{f.path}}:
  file.symlink:
    - name: {{pxe.root_dir|path_join(f.path)}}
    - target: {{f.target}}
    - user: {{f.get('user', pxe.user)}}
    - group: {{f.get('group', pxe.group)}}
    - mode: {{f.get('mode', 644)}}
    - makedirs: True
  {%- endif %}
{%- endfor %}