#!/bin/bash

terraform apply --auto-approve

sleep 120

terraform output  -json|jq .mykey.value -r >/tmp/mykey.pem && chmod 600 /tmp/mykey.pem

export ANSIBLE_HOST_KEY_CHECKING=false
. scripts/new_window.sh

ansible-playbook -i /usr/local/bin/terraform.py deploy/install-bastion-hosts.yml && sleep 120 &&  \
ansible-playbook -i /usr/local/bin/terraform.py deploy/install-postgres-core.yml  && \
ansible-playbook -i /usr/local/bin/terraform.py deploy/install-postgres-slaves.yml  && \
ansible-playbook -i /usr/local/bin/terraform.py deploy/install-consul.yml  &&\
ansible-playbook -i /usr/local/bin/terraform.py deploy/install-pgbouncer.yml && \
ansible-playbook -i /usr/local/bin/terraform.py deploy/install-redis-cluster.yml && \
ansible-playbook -i /usr/local/bin/terraform.py deploy/install-middleware-services.yml && \
ansible-playbook -i /usr/local/bin/terraform.py deploy/install-gitaly.yml && \
ansible-playbook -i /usr/local/bin/terraform.py deploy/install-sidekiq-asap.yml && \
ansible-playbook -i /usr/local/bin/terraform.py deploy/install-sidekiq-pipeline.yml && \
ansible-playbook -i /usr/local/bin/terraform.py deploy/install-sidekiq-realtime.yml && \
ansible-playbook -i /usr/local/bin/terraform.py deploy/install-frontend-services.yml && \
ansible-playbook -i /usr/local/bin/terraform.py deploy/install-monitoring.yml
