#!/bin/bash

mkdir -p ~/bin
WINDOWS_USERNAME=$(cmd.exe /C "echo %USERNAME%" | tr -d '\r\n')
WINDOWS_HOMEDIR=$(cmd.exe /C "echo %USERPROFILE%" |  awk -v RS='\\' -v ORS='/' '1' | sed 's/^.//;s/:/\/mnt\/c/' | tr -d '\r\n')


# terraform autocomplete (terraform installed in setup_system.sh)
if ! grep terraform ~/.bashrc > /dev/null ; then
    terraform -install-autocomplete
fi

# kubectl - check our own version as WSL2 docker installs one to /usr/local/bin
if [ ! -f ~/bin/kubectl ] ; then
    echo "installing kubectl..."
    pushd ~/bin
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    chmod +x kubectl
    echo 'source <(kubectl completion bash)' >> ~/.profile
    popd
fi

# helm
if [ -z $(which helm) ] ; then
    echo "installing helm..."
    curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | HELM_INSTALL_DIR=~/bin USE_SUDO=false bash
    echo 'source <(helm completion bash)' >> ~/.profile
fi

# Maven
if [ -z $(which mvn) ] ; then
    echo "installing maven..."
    pushd ~/
    MAVEN_VERSION="3.9.5"
    curl -LO https://dlcdn.apache.org/maven/maven-3/3.9.5/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz
    tar zxvf apache-maven-${MAVEN_VERSION}-bin.tar.gz
    ln -s apache-maven-${MAVEN_VERSION} apache-maven
    echo 'PATH=~/apache-maven/bin:$PATH' >> ~/.profile
    popd
fi

# Gradle
if [ -z $(which gradle) ] ; then
    echo "installing gradle..."
    pushd ~/
    GRADLE_VERSION="8.4"
    curl -LO https://services.gradle.org/distributions/gradle-8.4-bin.zip
    unzip gradle-${GRADLE_VERSION}-bin.zip
    ln -s gradle-8.4 gradle
    echo "PATH=~/gradle/bin:\$PATH" >> ~/.profile
    popd
fi

# confluent platform (SDK)
CONFLUENT_MAJOR_VERSION="7.5"
CONFLUENT_FULL_VERSION="${CONFLUENT_MAJOR_VERSION}.2"
CONFLUENT_SYMLINK=~/confluent
if [ ! -d ${CONFLUENT_SYMLINK} ] ; then
    echo "installing confluent sdk..."
    pushd ~/
    curl -O https://packages.confluent.io/archive/${CONFLUENT_MAJOR_VERSION}/confluent-${CONFLUENT_FULL_VERSION}.zip
    unzip confluent-${CONFLUENT_FULL_VERSION}.zip
    ln -s confluent-${CONFLUENT_FULL_VERSION} ${CONFLUENT_SYMLINK}
    echo "PATH=${CONFLUENT_SYMLINK}/bin:\$PATH" >> ~/.profile
    popd
fi

# confluent CLI
# confluent SDK normally ships an old CLI so ignore it...
if [ ! -f ~/bin/confluent ] ; then
    echo "installing confluent cli..."
    pushd ~/
    curl -sL --http1.1 https://cnfl.io/cli | sh -s -- latest
    mkdir -p ~/.confluent
    echo '{"disable_updates": true, "disable_plugins": true}' > ~/.confluent/config.json
    popd
fi

# xdg-open - for logging into confluent cloud and other SSOs
if [ -z $(which pip ) ]  ; then
    echo "rerun this script after installing python to install xdg-open"
elif [ -z $(which xdg-open) ] ; then
    echo "installing xdg-open-wsl..."
    # install xdg-open-wsl using your latest pip
    pip install --user git+https://github.com/cpbotha/xdg-open-wsl.git
    echo "RESTART YOUR SHELL TO ENABLE xdg-open"
fi

# k3d (kubernetes in docker)
if [ -z $(which k3d) ] ; then
    echo "installing k3d..."
    curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | K3D_INSTALL_DIR=~/bin USE_SUDO=false bash
fi

# istioctl
if [ ! -f ~/.istioctl/bin/istioctl ] ; then
    echo "installing istioctl..."
    curl -sL https://istio.io/downloadIstioctl | sh -
    echo 'export PATH=$HOME/.istioctl/bin:$PATH' >> ~/.profile
    # shell completion needs full install of istio... im not that interested
fi

# ~/.vimrc
if [ ! -f ~/.vimrc ] ; then
    echo "configure vim..."
    cp files/dot.vimrc ~/.vimrc
fi

if [ ! -f ~/bin/git-prompt.sh ] ; then
    # not packaged on linux git
    echo "installing git-prompt.sh..."
    curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh > ~/bin/git-prompt.sh
    chmod +x ~/bin/git-prompt.sh
    echo source ~/bin/git-prompt.sh >> ~/.profile
fi

# nicer shell prompt with kubernetes info
if ! grep bash_prompt.sh ~/.profile > /dev/null ; then
    echo "configure prompt..."
    cp files/bash_prompt.sh ~/bin
    echo 'source ~/bin/bash_prompt.sh' >> ~/.profile
fi

# maven cache -> windows host
if [ ! -e ~/.m2 ] ; then
    echo "symlink maven cache..."
    mkdir -p $WINDOWS_HOMEDIR/.m2
    ln -s $WINDOWS_HOMEDIR/.m2 ~/.m2
fi

# ssh settings and keys -> windows host
if [ ! -e ~/.ssh ] ; then
    echo "symlink .ssh dir..."
    mkdir -p $WINDOWS_HOMEDIR/.ssh
    chmod 0700 $WINDOWS_HOMEDIR/.ssh
    ln -s $WINDOWS_HOMEDIR/.ssh ~/.ssh
fi

if [ ! -e ~/.kube ] ; then
    echo "symlink .kube dir..."
    mkdir -p $WINDOWS_HOMEDIR/.kube
    chmod 0700 $WINDOWS_HOMEDIR/.kube
    ln -s $WINDOWS_HOMEDIR/.kube ~/.kube
fi