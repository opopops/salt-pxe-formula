{%- from "pxe/map.jinja" import pxe with context %}

include:
  - pxe.install

pxe_boot_dir:
  file.directory:
    - name: {{pxe.root_dir | path_join('boot')}}
    - user: {{pxe.user}}
    - group: {{pxe.group}}
    - dir_mode: 755
    - require:
      - file: pxe_root_dir

pxe_bios_boot_dir:
  file.symlink:
    - name: {{pxe.root_dir | path_join('bios', 'boot')}}
    - target: '../boot'
    - user: {{pxe.user}}
    - group: {{pxe.group}}
    - require:
      - file: pxe_bios_dir
      - file: pxe_boot_dir

pxe_efi32_boot_dir:
  file.symlink:
    - name: {{pxe.root_dir | path_join('efi32', 'boot')}}
    - target: '../boot'
    - user: {{pxe.user}}
    - group: {{pxe.group}}
    - require:
      - file: pxe_efi32_dir
      - file: pxe_boot_dir

pxe_efi64_boot_dir:
  file.symlink:
    - name: {{pxe.root_dir | path_join('efi64', 'boot')}}
    - target: '../boot'
    - user: {{pxe.user}}
    - group: {{pxe.group}}
    - require:
      - file: pxe_efi64_dir
      - file: pxe_efi64_dir

{%- for os, os_params in pxe.get('netboot', {}).iteritems() %}
  {%- if os == 'clonezilla' %}
    {%- for dist, dist_params in os_params.get('dists', {}).iteritems() %}
      {%- for arch in dist_params.get('archs', []) %}
pxe_boot_{{os}}_{{dist}}_dir:
  file.directory:
    - name: {{pxe.root_dir | path_join('boot', os, 'dist')}}
    - user: {{pxe.user}}
    - group: {{pxe.group}}
    - dir_mode: 755
    - makedirs: True
    - require:
      - file: pxe_boot_dir

pxe_boot_{{os}}_{{dist}}_{{arch}}:
  archive.extracted:
    - name: {{pxe.root_dir | path_join('boot', os, dist, arch)}}
    - source: {{os_params.base_url}}/clonezilla_live_{{dist}}/{{dist_params.version}}/clonezilla-live-{{dist_params.version}}-{{arch}}.zip
    - skip_verify: True
    - user: {{pxe.user}}
    - group: {{pxe.group}}
    - force: True
    - overwrite: True
    - enforce_toplevel: False
    - keep: False
    - if_missing: {{pxe.root_dir | path_join('boot', os, dist, arch)}}
    - require:
      - file: pxe_boot_{{os}}_{{dist}}_dir
      {%- endfor %}
    {%- endfor %}  
  {%- elif os in ['debian', 'ubuntu'] %}
    {%- for dist, dist_params in os_params.get('dists', {}).iteritems() %}
      {%- for arch in dist_params.get('archs', []) %}
pxe_boot_{{os}}_{{dist}}_dir:
  file.directory:
    - name: {{pxe.root_dir | path_join('boot', os, 'installer', 'dist')}}
    - user: {{pxe.user}}
    - group: {{pxe.group}}
    - dir_mode: 755
    - makedirs: True
    - require:
      - file: pxe_boot_dir

pxe_boot_{{os}}_{{dist}}_{{arch}}:
  archive.extracted:
    - name: {{pxe.root_dir | path_join('boot', os, 'installer', dist, arch)}}
    {%- if os == 'debian' %}
    - source: {{os_params.base_url}}/{{os}}/dists/{{dist}}/main/installer-{{arch}}/{{dist_params.version|default('current')}}/images/netboot/netboot.tar.gz
    {%- elif os == 'ubuntu' %}
    - source: {{os_params.base_url}}/{{os}}/dists/{{dist}}-updates/main/installer-{{arch}}/{{dist_params.version|default('current')}}/images/netboot/netboot.tar.gz
    {%- endif %}
    - skip_verify: True
    - options: --strip-components=3 
    - user: {{pxe.user}}
    - group: {{pxe.group}}
    - force: True
    - overwrite: True
    - enforce_toplevel: False
    - keep: False
    - if_missing: {{pxe.root_dir | path_join('boot', os, 'installer', dist, arch)}}
    - require:
      - file: pxe_boot_{{os}}_{{dist}}_dir
      {%- endfor %}
    {%- endfor %}
  {%- endif %}
{%- endfor %}
