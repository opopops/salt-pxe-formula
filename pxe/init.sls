{%- from "pxe/map.jinja" import pxe with context %}

include:
  - pxe.install
  {%- if pxe.netboot is defined %}
  - pxe.netboot
  {%- if pxe.preseed is defined %}
  - pxe.preseed
  {%- endif %}
