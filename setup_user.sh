#!/bin/bash

terraform -install-autocomplete
mkdir -p ~/bin

# kubectl
if [ -z $(which kubectl) ] ; then
    pushd ~/bin
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    chmod +x kubectl
    echo 'source <(kubectl completion bash)' >> ~/.profile
    popd
fi

# Maven
if [ -z $(which mvn) ] ; then
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
    pushd ~/
    curl -O https://packages.confluent.io/archive/${CONFLUENT_MAJOR_VERSION}/confluent-${CONFLUENT_FULL_VERSION}.zip
    unzip confluent-${CONFLUENT_FULL_VERSION}.zip
    ln -s confluent-${CONFLUENT_FULL_VERSION} ${CONFLUENT_SYMLINK}
    echo "PATH=${CONFLUENT_SYMLINK}/bin:\$PATH" >> ~/.profile
fi

# confluent CLI
# confluent SDK normally ships an old CLI so ignore it...
if [ ! -f ~/bin/confluent ] ; then
    pushd ~/
    curl -sL --http1.1 https://cnfl.io/cli | sh -s -- latest
    mkdir -p ~/.confluent
    echo '{"disable_updates": true, "disable_plugins": true}' > ~/.confluent/config.json
    popd
fi


# python env (different version of python)
if [ -z $(which pyenv) ] ; then
    curl https://pyenv.run | bash
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.profile
    echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.profile
    echo 'eval "$(pyenv init -)"' >> ~/.profile
    echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.profile
fi


# xdg-open - for logging into confluent cloud and other SSOs
if [ -z $(which pip ) ]  ; then
    echo "rerun this script after installing python to install xdg-open"
elif [ -z $(which xdg-open) ] ; then
    # install xdg-open-wsl using your latest pip
    pip install --user git+https://github.com/cpbotha/xdg-open-wsl.git
fi

echo "RESTART YOUR SHELL, then: pyenv install 3.12.0 if you want a python"