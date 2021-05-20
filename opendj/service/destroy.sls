# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import OPENDJ with context %}

opendj-pod-destroy:
  cmd.run:
    - name: podman pod rm --force {{ OPENDJ.projectname }}-opendj-pod
    - runas: {{ OPENDJ.hostuser.name }}
