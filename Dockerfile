FROM ubuntu:16.04
MAINTAINER Mariusz Karpiarz

# Kolla branch to check out
ARG K_BRANCH=master
# Kolla-Ansible branch to check out
ARG KA_BRANCH=master

RUN apt-get update
RUN apt-get install -y \
    git \
    curl \
    wget \
    python-dev \
    libffi-dev \
    gcc \
    libssl-dev \
    python-selinux
RUN curl https://bootstrap.pypa.io/get-pip.py | python
RUN pip install ansible==2.4

RUN mkdir -p /etc/ansible
ADD ansible.cfg /etc/ansible/ansible.cfg

# Clone and setup Kolla
WORKDIR /kolla
RUN git clone https://github.com/openstack/kolla -b $K_BRANCH
RUN git clone https://github.com/openstack/kolla-ansible -b $KA_BRANCH
RUN pip install --upgrade -r kolla/requirements.txt
RUN pip install --upgrade -r kolla-ansible/requirements.txt
RUN cp -r kolla-ansible/etc/kolla /etc/kolla/
RUN kolla-ansible/tools/generate_passwords.py