dependencies:
  pkg.installed:
    - names:
      - ca-certificates
      - curl
      - openssh-server
      - postfix
      - tzdata
      - perl

activate_ufw:
  cmd.run:
    - name: |
        sudo ufw enable 
        sudo ufw allow http 
        sudo ufw allow https 
        sudo ufw allow OpenSSH
#    - unless: sudo ufw status | grep "Status: active"


#install_gitlab_repo:
#  cmd.run:
#    - name: |
#        cd /tmp
#        curl -LO https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh
#        sudo bash /tmp/script.deb.sh
#    - onlyif:
#        - test -z "$(dpkg -l | grep gitlab-ce)"

install_gitlab_repo:
  cmd.run:
    - name: |
        cd /tmp
        curl -LO https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh
        sudo bash /tmp/script.deb.sh
    - unless: dpkg-query -l gitlab-ce

install_gitlab_ce:
  pkg.installed:
    - name: gitlab-ce


change_gitlab_username_and_password:
  cmd.run:
    - name: |
        sudo gitlab-rails console  <<-EOF
        user = User.find_by_username('root')
        user.username = '{{ pillar['gitlab']['new_username'] }}'
        user.password = '{{ pillar['gitlab']['new_password'] }}'
        user.password_confirmation = '{{ pillar['gitlab']['new_password'] }}'
        user.save!
        EOF
    - unless: "sudo gitlab-rails runner 'puts User.find_by_username(\"saltlabs_noc\").present?' | grep -q 'true'"

#    -unless: "sudo gitlab-rails runner 'puts User.find_by_username(\"{{ pillar['gitlab']['new_username'] }}\").present?' | grep -q 'true'"
#    - require:
#      - pkg: gitlab-ce      # Ensure GitLab is installed before executing this state
#    -unless: "sudo gitlab-rails runner 'puts User.find_by_username("{{ pillar['gitlab']['new_username'] }}").present?' | grep -q 'true'"
#    - unless: test -n "$(sudo gitlab-rails  <<-EOF\n user = User.find_by_username('{{ pillar['gitlab']['new_username'] }}')\n EOF)"
#    - unless: "$(sudo gitlab-rails  <<-EOF\n User.find_by_username('{{ pillar['gitlab']['new_username'] }}').present? \n EOF)"
#    - shell: /bin/bash
#    - user: root
