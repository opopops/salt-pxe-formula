{%- from "pxe/map.jinja" import pxe with context %}

{%- for preseed in pxe.get('preseed', []) %}
{%- if preseed.source_dir is defined %}
    {%- if preseed.path is defined %}
{{pxe.root_dir|path_join('preseed', preseed.path)}}:
    {%- else %}
{{pxe.root_dir|path_join('preseed')}}:
    {%- endif %}
  file.recurse:
    - source: {{preseed.source_dir}}
    - user: {{pxe.user}}
    - group: {{pxe.group}}
    - dir_mode: 755
    - file_mode: 644
    - makedirs: True
    - template: jinja
    - defaults: {{ preseed.get('settings', {}) }}
  {%- elif preseed.source is defined %}
{{pxe.root_dir|path_join('preseed', preseed.path)}}:
  file.managed:
    - source: {{preseed.source}}
    {%- if preseed.source_hash is defined %}
    - source_hash: {{ preseed.source_hash }}
    {%- endif %}
    - user: {{pxe.user}}
    - group: {{pxe.group}}
    - mode: 644
    - makedirs: True
    - template: jinja
    - defaults: {{ preseed.get('settings', {}) }}
  {%- endif %}
{%- endfor %}