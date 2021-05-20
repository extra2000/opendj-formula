# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import OPENDJ with context %}

opendj-image-present:
  cmd.run:
    - name: podman pull {{ OPENDJ.opendj.image.name }}
    - retry:
        attempts: 10
        interval: 5
        until: true
    - runas: {{ OPENDJ.hostuser.name }}

opendj-pod-destroy-if-exists:
  module.run:
    - state.sls:
      - mods:
        - opendj.service.opendj.destroy

opendj-pod-running:
  cmd.run:
    - name: podman play kube --network=opendjnet opendj-pod.yaml
    - cwd: /opt/opendj
    - runas: {{ OPENDJ.hostuser.name }}
    - require:
      - cmd: opendj-image-present
      - module: opendj-pod-destroy-if-exists
