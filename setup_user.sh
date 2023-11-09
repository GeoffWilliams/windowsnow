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
    echo 'PATH=~/gradle/bin:$PATH' >> ~/.profile
    popd
fi