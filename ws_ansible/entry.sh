#!/bin/sh

chmod -R 0600 /root/.ssh/

if [ ! -z "$DEBUG" ]; then
  I_EXTRA_ARGS="-vvv"
fi

set -x
<<<<<<< HEAD
<<<<<<< HEAD
ansible-playbook ./all.yml --check --diff 
=======
ansible-playbook ./playbook.yml --check --diff 
>>>>>>> aa11044 (Update)
=======
ansible-playbook ./playbook.yml --check --diff 
>>>>>>> aa11044 (Update)
