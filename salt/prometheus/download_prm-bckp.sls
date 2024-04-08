install_wget:
  pkg.installed:
    - name: wget

prometheus_download:
  cmd.run:
    - name: |
        cd /
        wget https://github.com/prometheus/prometheus/releases/download/v2.45.1/prometheus-2.45.1.linux-amd64.tar.gz
        tar -xzf prometheus-2.45.1.linux-amd64.tar.gz
        chmod -R 755 /prometheus-2.45.1.linux-amd64/
  
    - require:
      - pkg: wget
    - unless: test -d /prometheus-2.45.1.linux-amd64/data
    - unless: test -f /prometheus-2.45.1.linux-amd64/prometheus.yml
