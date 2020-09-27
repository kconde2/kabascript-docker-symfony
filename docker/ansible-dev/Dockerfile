FROM ubuntu:20.04

ENV TZ=Europe/Paris
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    apt-get install -y gnupg2 python python3-pip sshpass git openssh-client wget openssh-server && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean

RUN python3 -m pip install --upgrade pip cffi && \
    pip install --upgrade ansible && \
    pip install mitogen ansible-lint bcrypt && \
    pip install --upgrade pywinrm

COPY docker/ansible-dev/requirements.txt /tmp/
RUN pip install -r /tmp/requirements.txt

RUN mkdir /ansible && \
    mkdir -p /etc/ansible && \
    echo 'localhost' > /etc/ansible/hosts

COPY docker/ansible-dev/mount-ssh.sh /bin/mount-ssh.sh
RUN chmod +x /bin/mount-ssh.sh && /bin/mount-ssh.sh

# SSH Forwarding
RUN cp /etc/ssh/sshd_config /etc/ssh/sshd_config_bak && \
    sed -i "s/^.*X11Forwarding.*$/X11Forwarding yes/" /etc/ssh/sshd_config && \
    sed -i "s/^.*X11UseLocalhost.*$/X11UseLocalhost no/" /etc/ssh/sshd_config && \
    grep "^X11UseLocalhost" /etc/ssh/sshd_config || echo "X11UseLocalhost no" >> /etc/ssh/sshd_config

# Docker
RUN apt-get update && \
    apt-get -y install apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    software-properties-common && \
    curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg > /tmp/dkey; apt-key add /tmp/dkey && \
    add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
    $(lsb_release -cs) \
    stable" && \
    apt-get update && \
    apt-get -y install docker-ce

WORKDIR /root/ansible
ENTRYPOINT ["/bin/mount-ssh.sh"]

CMD [ "ansible-playbook", "--version"]
