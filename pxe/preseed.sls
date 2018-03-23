{%- from "pxe/map.jinja" import pxe with context %}

{%- for preseed in pxe.get('preseed', []) %}
{{pxe.root_dir|path_join('preseed', preseed.os, preseed.oscodename, preseed.file )}}:
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
{%- endfor %}