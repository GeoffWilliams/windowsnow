#!/bin/bash
apt-get update 
apt-get install -y \
    gnupg \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    curl \
    openjdk-11-jre-headless \
    bash-completion \
    build-essential \
    jq \
    kafkacat \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    libncursesw5-dev \
    xz-utils \
    tk-dev \
    libxml2-dev \
    libxmlsec1-dev \
    libffi-dev \
    liblzma-dev \
    net-tools

# Terraform
if [ -z $(which terraform) ] ; then 
    wget -O- https://apt.releases.hashicorp.com/gpg | \
    gpg --dearmor | \
    tee /usr/share/keyrings/hashicorp-archive-keyring.gpg \
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    tee /etc/apt/sources.list.d/hashicorp.list
    apt update
    apt-get install -y terraform
fi

# gcloud cli
if [ -z $(which gcloud) ] ; then
    echo "deb https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
    apt-get update &&  apt-get install -y google-cloud-cli
fi



# AWS CLI
if [ -z "$(which aws)" ] ; then
    apt install -y unzip
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    ./aws/install
fi

# Azure CLI
if [ -z $(which az) ] ; then
    curl -sL https://aka.ms/InstallAzureCLIDeb | bash
fi

# xq
if [ -z $(which xq) ] ; then
    curl -sSL https://raw.githubusercontent.com/sibprogrammer/xq/master/scripts/install.sh | bash
fi
