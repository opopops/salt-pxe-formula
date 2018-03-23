{%- from "pxe/map.jinja" import pxe with context %}

include:
  - pxe.install
  {%- if pxe.netboot is defined %}
  - pxe.netboot
  {%- endif %}
  {%- if pxe.preseed is defined %}
  - pxe.preseed
  {%- endif %}
