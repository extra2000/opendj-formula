# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import OPENDJ with context %}

{% if OPENDJ.hostuser.name == 'root' %}
  {% set cni_path = '/etc/cni/net.d/' %}
{% else %}
  {% set cni_path = '/home/' + OPENDJ.hostuser.name + '/.config/cni/net.d' %}
{% endif %}

/opt/opendj:
  file.directory:
    - user: {{ OPENDJ.hostuser.name }}
    - group: {{ OPENDJ.hostuser.group }}

{{ cni_path }}:
  file.directory:
    - user: {{ OPENDJ.hostuser.name }}
    - group: {{ OPENDJ.hostuser.group }}
    - makedirs: true

{{ cni_path }}/podman-network-opendjnet.conflist:
  file.managed:
    - source: salt://opendj/files/podman-network-opendjnet.conflist.jinja
    - user: {{ OPENDJ.hostuser.name }}
    - group: {{ OPENDJ.hostuser.group }}
    - template: jinja
    - context:
      pod: {{ OPENDJ.pod }}

/opt/opendj/opendj-pod.yaml:
  file.managed:
    - source: salt://opendj/files/opendj-pod.yaml
    - user: {{ OPENDJ.hostuser.name }}
    - group: {{ OPENDJ.hostuser.group }}
    - template: jinja
    - context:
      projectname: {{ OPENDJ.projectname }}
      opendj: {{ OPENDJ.opendj }}
