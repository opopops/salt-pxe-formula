{%- from "pxe/map.jinja" import pxe with context %}

include:
  - pxe.install

{%- for os, os_params in pxe.get('netboot', {}).items() %}
  {%- if os == 'clonezilla' %}
    {%- for dist, versions in os_params.get('dists', {}).items() %}
      {%- for version in versions %}
        {%- for arch in version.get('archs', []) %}
pxe_boot_{{os}}_{{dist}}_{{version.version}}_dir:
  file.directory:
    - name: {{pxe.root_dir | path_join('boot', os, 'dist')}}
    - user: {{pxe.user}}
    - group: {{pxe.group}}
    - mode: 755
    - makedirs: True
    - require:
      - file: pxe_boot_dir

pxe_boot_{{os}}_{{dist}}_{{version.version}}_{{arch}}:
  archive.extracted:
    - name: {{pxe.root_dir | path_join('boot', os, dist, version.version, arch)}}
    - source: {{os_params.base_url}}/clonezilla_live_{{dist}}/{{version.version}}/clonezilla-live-{{version.version}}-{{arch}}.zip
    - skip_verify: True
    - user: {{pxe.user}}
    - group: {{pxe.group}}
    - force: True
    - enforce_toplevel: False
    - keep_source: {{os_params.get('keep_source', False)}}
    - overwrite: {{os_params.get('overwrite', False)}}
    - require:
      - file: pxe_boot_{{os}}_{{dist}}_{{version.version}}_dir

{%- if version.get('default', False) %}
pxe_boot_{{os}}_{{dist}}_{{version.version}}_{{arch}}_default:
  file.symlink:
    - name: {{pxe.root_dir | path_join('boot', os, dist, 'current')}}
    - target: {{version.version}}
    - user: {{pxe.user}}
    - group: {{pxe.group}}
    - force: True
{%- endif %}
        {%- endfor %}
      {%- endfor %}
    {%- endfor %}
  {%- elif os in ['debian', 'ubuntu'] %}
    {%- for dist, versions in os_params.get('dists', {}).items() %}
      {%- for version in versions %}
        {%- for arch in version.get('archs', []) %}
pxe_boot_{{os}}_{{dist}}_{{version.version}}_dir:
  file.directory:
    - name: {{pxe.root_dir | path_join('boot', os, 'installer', 'dist')}}
    - user: {{pxe.user}}
    - group: {{pxe.group}}
    - mode: 755
    - makedirs: True
    - require:
      - file: pxe_boot_dir

pxe_boot_{{os}}_{{dist}}_{{version.version}}_{{arch}}:
  archive.extracted:
    - name: {{pxe.root_dir | path_join('boot', os, 'installer', dist, version.version, arch)}}
    - source: {{os_params.base_url}}/{{os}}/dists/{{dist}}/main/installer-{{arch}}/{{version.version|default('current')}}/images/netboot/netboot.tar.gz
    - skip_verify: True
    - options: --strip-components=3
    - user: {{pxe.user}}
    - group: {{pxe.group}}
    - force: True
    - enforce_toplevel: False
    - keep_source: {{os_params.get('keep_source', False)}}
    - overwrite: {{os_params.get('overwrite', False)}}
    - require:
      - file: pxe_boot_{{os}}_{{dist}}_{{version.version}}_dir

{%- if version.get('default', False) %}
pxe_boot_{{os}}_{{dist}}_{{version.version}}_{{arch}}_default:
  file.symlink:
    - name: {{pxe.root_dir | path_join('boot', os, 'installer', dist, 'current')}}
    - target: {{version.version}}
    - user: {{pxe.user}}
    - group: {{pxe.group}}
    - force: True
{%- endif %}
        {%- endfor %}
      {%- endfor %}
    {%- endfor %}
  {%- endif %}
{%- endfor %}
