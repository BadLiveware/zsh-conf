# Keep it en_GB
export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"
export LANGUAGE="en_US:en"
export LC_CTYPE="en_GB.UTF-8"
export LC_COLLATE="en_GB.UTF-8"
export LC_MESSAGES="en_GB.UTF-8"

# sv_SE
export LC_NUMERIC="sv_SE.utf8"
export LC_TIME="sv_SE.utf8"
export LC_MONETARY="sv_SE.utf8"
export LC_PAPER="sv_SE.utf8"
export LC_NAME="sv_SE.UTF-8"
export LC_ADDRESS="sv_SE.UTF-8"
export LC_TELEPHONE="sv_SE.UTF-8"
export LC_MEASUREMENT="sv_SE.utf8"
export LC_IDENTIFICATION="sv_SE.UTF-8"

# DOCKER_DISTRO="ubuntu"
# DOCKER_DIR=/mnt/wsl/shared-docker
# DOCKER_SOCK="$DOCKER_DIR/docker.sock"
# export DOCKER_HOST="unix://$DOCKER_SOCK"
# # if [ ! -S "$DOCKER_SOCK" ]; then
# #    mkdir -pm o=,ug=rwx "$DOCKER_DIR"
# #    chgrp docker "$DOCKER_DIR"
# #    /mnt/c/Windows/System32/wsl.exe -d $DOCKER_DISTRO sh -c "nohup sudo -b dockerd < /dev/null > $DOCKER_DIR/dockerd.log 2>&1"
# # fi
# if service docker status 2>&1 | grep -q "is not running"; then
#   mkdir -pm o=,ug=rwx "$DOCKER_DIR"
#   chgrp docker "$DOCKER_DIR"
#   wsl.exe -d "${WSL_DISTRO_NAME}" -u root -e /usr/sbin/service docker start >$DOCKER_DIR/dockerd.log 2>&1
# fi

export DOCKER_BUILDKIT=1
