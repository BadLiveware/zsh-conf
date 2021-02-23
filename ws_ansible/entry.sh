#!/bin/sh

chmod -R 0600 /root/.ssh/

if [ ! -z "$DEBUG" ]; then
  I_EXTRA_ARGS="-vvv"
fi

set -x
ansible-playbook ./all.yml --check --diff 
