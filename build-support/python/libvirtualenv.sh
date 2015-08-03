#!/usr/bin/env bash

# Creates a virtualenv for a given set of pip requirements in a fingerprinted directory.
#
# Usage:
#   setup_virtualenv <name> (<requirements> | <path_to_requirements.txt>) [additional pip options]
#
# source:
#   https://raw.githubusercontent.com/twitter/commons/master/build-support/python/libvirtualenv.sh


function setup_tmp_virtualenv() {
  SCRIPT="$1"; shift        # 'rbt'
  PIP_INSTALL_ARGS="$@"     # '--allow-external RBTools --allow-unverified RBTools'

  FINGERPRINT=$(echo ${SCRIPT} ${REQUIREMENTS} | openssl md5 | cut -d' ' -f2)
  HERE=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)
  VENV_DIR="$HERE/../${SCRIPT}.venv"

  echo "Bootstrapping ${SCRIPT} as an empty virtualenv with ${PIP_INSTALL_ARGS}"
  rm -fr "${VENV_DIR}"
  "$HERE/../virtualenv" "${VENV_DIR}"
  source "${VENV_DIR}/bin/activate"
}

function setup_virtualenv() {
  SCRIPT="$1"; shift        # 'rbt'
  REQUIREMENTS="$1"; shift  # 'RBTools==0.5.5' or 'path/to/requirements.txt'
  PIP_INSTALL_ARGS="$@"     # '--allow-external RBTools --allow-unverified RBTools'

  if [[ ${REQUIREMENTS} == *"requirements.txt" ]]; then
    if ! [ -f ${REQUIREMENTS} ]; then
      echo "${REQUIREMENTS} doesn't exist!  Cannot setup virtualenv!" && exit 1
    fi
    FINGERPRINT=$(echo ${SCRIPT} | cat - ${REQUIREMENTS} | openssl md5 | cut -d' ' -f2)
    PIP_INSTALL_ARGS="-r ${REQUIREMENTS} ${PIP_INSTALL_ARGS}"
    REQUIREMENTS=""
  else
    FINGERPRINT=$(echo ${SCRIPT} ${REQUIREMENTS} | openssl md5 | cut -d' ' -f2)
  fi

  HERE=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)
  VENV_DIR="$HERE/../${SCRIPT}.venv"
  BOOTSTRAPPED_FILE="${VENV_DIR}/BOOTSTRAPPED.${FINGERPRINT}"
  if ! [ -f ${BOOTSTRAPPED_FILE} ]; then
    echo "Bootstrapping ${SCRIPT} with ${PIP_INSTALL_ARGS}"
    rm -fr "${VENV_DIR}"
    "$HERE/../virtualenv" "${VENV_DIR}"
    source "${VENV_DIR}/bin/activate"
    if  pip install ${REQUIREMENTS} ${PIP_INSTALL_ARGS}; then
      touch "${BOOTSTRAPPED_FILE}"
    else
      echo "Setting up virtualenv failed!" && exit 1
    fi
  else
    source "${VENV_DIR}/bin/activate"
  fi
}
