# using a lot of https://hub.docker.com/r/philm/ansible_playbook/dockerfile/

# Alpine is a lightweight version of Linux.
# apline:latest could also be used
FROM alpine:3.13

RUN apk --update --no-cache add \
        ca-certificates \
        git \
        openssh-client \
        openssl \
        python3\
        py3-pip \
        py3-cryptography \
        py3-paramiko \
        rsync \
        sshpass \
        bash

RUN apk --update add --virtual \
        .build-deps \
        python3-dev \
        libffi-dev \
        openssl-dev \
        build-base \
        curl \
 && pip3 install --upgrade \
        pip \
        cffi \
 && pip3 install \
        ansible \
        ansible-lint \
 && apk del \
        .build-deps \
 && rm -rf /var/cache/apk/*

# Makes a directory for ansible playbooks
RUN mkdir -p /ansible/playbooks
# Makes the playbooks directory the working directory
WORKDIR /ansible/playbooks
COPY ./ansible/ .
RUN ansible-galaxy collection install -r requirements.yml

# Sets environment variables
ENV ANSIBLE_GATHERING smart
ENV ANSIBLE_HOST_KEY_CHECKING False
ENV ANSIBLE_RETRY_FILES_ENABLED False
ENV ANSIBLE_ROLES_PATH /ansible/playbooks/roles
ENV ANSIBLE_INVENTORY /ansible/playbooks/inventory.ini
ENV ANSIBLE_SSH_PIPELINING True

# Sets entry point (same as running ansible-playbook)
COPY ./entry.sh .
ENTRYPOINT ["./entry.sh"]