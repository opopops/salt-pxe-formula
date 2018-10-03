{%- from "pxe/map.jinja" import pxe with context %}

pxe_packages:
  pkg.installed:
    - pkgs: {{ pxe.pkgs }}

pxe_root_dir:
  file.directory:
    - name: {{pxe.root_dir}}
    - user: {{pxe.user}}
    - group: {{pxe.group}}
    - mode: 755
    - require:
      - pkg: pxe_packages

pxe_boot_dir:
  file.directory:
    - name: {{pxe.root_dir | path_join('boot')}}
    - user: {{pxe.user}}
    - group: {{pxe.group}}
    - mode: 755
    - require:
      - file: pxe_root_dir

pxe_web_dir:
  file.directory:
    - name: {{pxe.root_dir | path_join('www')}}
    - user: {{pxe.user}}
    - group: {{pxe.group}}
    - dir_mode: 755
    - file_mode: 644
    - recurse:
      - user
      - group
      - mode
    - require:
      - file: pxe_root_dir

pxe_pxelinux_conf_dir:
  file.directory:
    - name: {{pxe.root_dir | path_join('pxelinux.cfg')}}
    - user: {{pxe.user}}
    - group: {{pxe.group}}
    - mode: 755
    - require:
      - file: pxe_root_dir

pxe_bios_dir:
  file.copy:
    - name: {{pxe.root_dir | path_join('bios')}}
    - source: {{pxe.bios_modules_dir}}
    - user: {{pxe.user}}
    - group: {{pxe.group}}
    - mode: 755
    - makedirs: True
    - force: True
    - require:
      - file: pxe_root_dir

pxe_bios_pxelinux_conf_dir:
  file.symlink:
    - name: {{pxe.root_dir | path_join('bios', 'pxelinux.cfg')}}
    - target: {{pxe.root_dir | path_join('pxelinux.cfg')}}
    - user: {{pxe.user}}
    - group: {{pxe.group}}
    - require:
      - file: pxe_bios_dir
      - file: pxe_pxelinux_conf_dir

pxe_bios_boot_dir:
  file.symlink:
    - name: {{pxe.root_dir | path_join('bios', 'boot')}}
    - target: '../boot'
    - user: {{pxe.user}}
    - group: {{pxe.group}}
    - require:
      - file: pxe_bios_dir

pxe_pxelinux_file:
  file.copy:
    - name: {{pxe.root_dir | path_join('bios', 'pxelinux.0')}}
    - source: {{pxe.pxelinux_file}}
    - user: {{pxe.user}}
    - group: {{pxe.group}}
    - mode: 644
    - force: True
    - require:
      - file: pxe_bios_dir

{%- if salt['grains.get']('os') in ['Debian', 'Ubuntu'] %}
pxe_bios_memtest_file:
  file.copy:
    - name: {{pxe.root_dir | path_join('bios', 'memtest86+.bin')}}
    - source: {{pxe.memtest_file}}
    - user: {{pxe.user}}
    - group: {{pxe.group}}
    - mode: 644
    - makedirs: True
    - force: True
{%- endif %}

pxe_efi32_dir:
  file.copy:
    - name: {{pxe.root_dir | path_join('efi32')}}
    - source: {{pxe.efi32_modules_dir}}
    - user: {{pxe.user}}
    - group: {{pxe.group}}
    - mode: 755
    - makedirs: True
    - force: True

pxe_efi32_pxelinux_conf_dir:
  file.symlink:
    - name: {{pxe.root_dir | path_join('efi32', 'pxelinux.cfg')}}
    - target: {{pxe.root_dir | path_join('pxelinux.cfg')}}
    - user: {{pxe.user}}
    - group: {{pxe.group}}
    - require:
      - file: pxe_efi32_dir
      - file: pxe_pxelinux_conf_dir

pxe_efi32_boot_dir:
  file.symlink:
    - name: {{pxe.root_dir | path_join('efi32', 'boot')}}
    - target: '../boot'
    - user: {{pxe.user}}
    - group: {{pxe.group}}
    - require:
      - file: pxe_efi32_dir

pxe_efi32_syslinux_file:
  file.copy:
    - name: {{pxe.root_dir | path_join('efi32', 'syslinux.efi')}}
    - source: {{pxe.efi32_syslinux_file}}
    - user: {{pxe.user}}
    - group: {{pxe.group}}
    - mode: 644
    - makedirs: True
    - force: True
    - require:
      - file: pxe_efi32_dir

{%- if salt['grains.get']('os') in ['Debian', 'Ubuntu'] %}
pxe_efi32_memtest_file:
  file.copy:
    - name: {{pxe.root_dir | path_join('efi32', 'memtest86+.bin')}}
    - source: {{pxe.memtest_file}}
    - user: {{pxe.user}}
    - group: {{pxe.group}}
    - mode: 644
    - makedirs: True
    - force: True
    - require:
      - file: pxe_efi32_dir
{%- endif %}



pxe_efi64_dir:
  file.copy:
    - name: {{pxe.root_dir | path_join('efi64')}}
    - source: {{pxe.efi64_modules_dir}}
    - user: {{pxe.user}}
    - group: {{pxe.group}}
    - mode: 755
    - force: True

pxe_efi64_pxelinux_conf_dir:
  file.symlink:
    - name: {{pxe.root_dir | path_join('efi64', 'pxelinux.cfg')}}
    - target: {{pxe.root_dir | path_join('pxelinux.cfg')}}
    - user: {{pxe.user}}
    - group: {{pxe.group}}
    - require:
      - file: pxe_efi64_dir
      - file: pxe_pxelinux_conf_dir

pxe_efi64_boot_dir:
  file.symlink:
    - name: {{pxe.root_dir | path_join('efi64', 'boot')}}
    - target: '../boot'
    - user: {{pxe.user}}
    - group: {{pxe.group}}
    - require:
      - file: pxe_efi64_dir

pxe_efi64_syslinux_file:
  file.copy:
    - name: {{pxe.root_dir | path_join('efi64', 'syslinux.efi')}}
    - source: {{pxe.efi64_syslinux_file}}
    - user: {{pxe.user}}
    - group: {{pxe.group}}
    - mode: 644
    - force: True
    - require:
      - file: pxe_efi64_dir

{%- if salt['grains.get']('os') in ['Debian', 'Ubuntu'] %}
pxe_efi64_memtest_file:
  file.copy:
    - name: {{pxe.root_dir | path_join('efi64', 'memtest86+.bin')}}
    - source: {{pxe.memtest_file}}
    - user: {{pxe.user}}
    - group: {{pxe.group}}
    - mode: 644
    - force: True
    - require:
      - file: pxe_efi32_dir
{%- endif %}
