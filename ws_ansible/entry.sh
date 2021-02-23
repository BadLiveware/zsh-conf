#!/bin/sh

chmod -R 0600 /root/.ssh/
ansible all -m ansible.builtin.setup -v 