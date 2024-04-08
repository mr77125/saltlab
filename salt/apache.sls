install_apache:
  pkg.installed:
    - name: apache2
   # - onlyif: grains['os'] == 'Debian' and grains['id'] == 'minion1'

/var/www/html/index.html:
  file.managed:
    - contents_pillar: apache-content
    - user: root
    - group: root
    - mode: 644
