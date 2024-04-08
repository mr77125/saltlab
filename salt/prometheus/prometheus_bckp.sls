create_prometheus_user:
  user.present:
    - name: prometheus
    - system: True
    - shell: /bin/false

create_prometheus_group:
  group.present:
    - name: prometheus
    - system: True

/etc/systemd/system/prometheus.service:
  file.managed:
    - contents: |
        [Unit]
        Description=Prometheus Server
        Wants=network-online.target
        After=network-online.target

        [Service]
        User=prometheus
        Group=prometheus
        Type=simple
        ExecStart=/prometheus-2.45.1.linux-amd64/prometheus --config.file=/prometheus-2.45.1.linux-amd64/prometheus.yml --storage.tsdb.path=/prometheus-2.45.1.linux-amd64/data

        [Install]
        WantedBy=multi-user.target
    - user: root
    - group: root
    - mode: 0644
    - require:
      - user: prometheus_user
      - group: prometheus_group


start_prometheus_service:
  service.running:
    - name: prometheus
    - enable: True

reload_prometheus_service:
  cmd.run:
    - name: systemctl daemon-reload
    - onchanges:
      - file: /etc/systemd/system/prometheus.service

