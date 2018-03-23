{%- from "pxe/map.jinja" import pxe with context %}

{%- for script in pxe.get('script', []) %}
  {%- if script.source_dir is defined %}
    {%- if script.path is defined %}
{{pxe.root_dir|path_join('scripts', script.path)}}:
    {%- else %}
{{pxe.root_dir|path_join('scripts')}}:
    {%- endif %}
  file.recurse:
    - source: {{script.source}}
    - user: {{pxe.user}}
    - group: {{pxe.group}}
    - dir_mode: 755
    - file_mode: 644
    - makedirs: True
    - template: jinja
    - defaults: {{ preseed.get('settings', {}) }}
  {%- elif script.source is defined %}
{{pxe.root_dir|path_join('scripts', script.path)}}:
  file.managed:
    - source: {{script.source}}
    - user: {{pxe.user}}
    - group: {{pxe.group}}
    - mode: 644
    - makedirs: True
    - template: jinja
    - defaults: {{ preseed.get('settings', {}) }}
  {%- endif %}
{%- endfor %}
