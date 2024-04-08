haproxy_config:
  file.managed:
    - name: /etc/haproxy/haproxy.cfg
    - source: salt://haproxy/haproxy.cfg
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: install_haproxy  # Ensure installed lb
