# Bootstrapping
Run `bootstrap.ps1` to bootstrap the windows system to a point that it can be configured with ansible

# Configuration management
Run Invoke-Ansible.ps1 to configure ansible according to the playbook `all.yml` in ./ansible/

This script will auto-generate a ssh config with up to date information(IP) for ansible to connect. This is needed as there is not a stable way to connect to WSL(IP may change on reboot)