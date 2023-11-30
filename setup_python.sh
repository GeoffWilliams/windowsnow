#!/bin/bash
PYTHON_VERSION=3.12.0

if [ -z $(which pyenv) ] ; then
    echo "run ./setup_pyenv.sh first"
    exit 1
fi

if ! (pyenv versions | grep ${PYTHON_VERSION}) ; then
    echo "Installing python ${PYTHON_VERSION}..."
    pyenv install -f ${PYTHON_VERSION}
fi

if ! grep '^pyenv shell' ~/.profile > /dev/null ; then
    echo "setup python shell..."

    echo "pyenv shell ${PYTHON_VERSION}" >> ~/.profile
    echo "python --version" >> ~/.profile

    echo "logout and back in again to enable python"
fi