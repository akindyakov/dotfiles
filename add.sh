#!/usr/bin/env bash

set -e -x

_SRC_DIR="${HOME}/source/git.dotfiles"
_HOME_TMP="${HOME}/tmp"
_OLD_VERSION_DIR="${HOME}/tmp/old_version"

log() {
  local msg="$@"
  echo "[log] ${msg}" >&2
}

err() {
  local msg="$@"
  echo "[err] ${msg}" >&2
  exit 1
}

backupold() {
  mkdir --parents "${_OLD_VERSION_DIR}"
  local back_up_path="${_OLD_VERSION_DIR}/$(basename $dst).$(date +'%s.%N')"
  log "Real file in destination node \"${dst}\", back up it to \"${back_up_path}\""
  mv "${dst}" "${back_up_path}"
}

if [[ -z "${1}" || -z "${2}" ]]; then
  err "Usage ./$(basename ${0}) category filepath"
fi

_CATEGORY="${1}"
_PATH="$(readlink -f ${2})"

_FILENAME="$(basename ${_PATH} | sed -e 's/^\.//')"

_REPO_PATH="${_SRC_DIR}/${_CATEGORY}/${_FILENAME}"

if [[ -f "${_REPO_PATH}" ]]; then
  $EDITOR -d "${_PATH}" "${_REPO_PATH}"
  backupold "${_PATH}"
else
  mkdir --parents "$(dirname ${_REPO_PATH})"
  mv "${_PATH}" "${_REPO_PATH}"
  echo "# Original ${_PATH}" >> "${_REPO_PATH}"

  cd "${_SRC_DIR}"
  git add "${_CATEGORY}/${_FILENAME}"
  cd -
fi

log "link ${_PATH} to ${_REPO_PATH}"
ln -s "${_REPO_PATH}" "${_PATH}"
