#!/usr/bin/env bash

set -e

SRC_DIR="$(pwd)"
HOME_TMP="${HOME}/tmp"
OLD_VERSION_DIR="${HOME_TMP}/old_version"
BIN_DIR="${HOME}/bin"

err() {
  local msg="$@"
  echo "${msg}" >&2
  exit 1
}

warn() {
  local msg="$@"
  echo "${msg}"
}

assert_src_dir() {
  if [[ ! -f "${SRC_DIR}/install.sh" ]]; then
    err "Wrong base directory, run install.sh from source directory."
  fi
}

init_env() {
  mkdir --parents "${HOME_TMP}"
  mkdir --parents "${OLD_VERSION_DIR}"
  mkdir --parents "${BIN_DIR}"
  if [[ ! -L "${HOME}/Downloads" && -d "${HOME}/Downloads" ]]; then
    mv "${HOME}/Downloads/"* "${HOME_TMP}/"
    rm --recursive "${HOME}/Downloads"
    ln --symbolic "${HOME_TMP}" "${HOME}/Downloads"
  fi
}

install_file() {
  local src="${SRC_DIR}/$1"
  local dst="$2"

  if [[ ! -f "${src}" ]]; then
    err "The source file \"${dst}\" does not exist"
  fi
  if [[ -e "${dst}" ]] && [[ ! -L "${dst}" ]]; then
    local back_up_path="${OLD_VERSION_DIR}/$(basename $dst).$(date +'%s.%N')"
    warn "Real file in destination node \"${dst}\", back up it to \"${back_up_path}\""
    mv "${dst}" "${back_up_path}"
  fi
  local dst_dir="$(dirname ${dst})"
  if [[ ! -d "${dst_dir}" ]]; then
    mkdir --parents "${dst_dir}"
  fi
  if [[ -L "${dst}" ]]; then
    local dst_realpath="$(readlink ${dst})"
    if [[ "${dst_realpath}" != "${src}" ]]; then
      err "Unexpected symbolic link of target: ${dst} -> ${dst_realpath}"
    fi
  else
    ln --symbolic "${src}" "${dst}"
  fi
}

scripts() {
  install_file "bin/screenshot" "${HOME}/bin/screenshot"
}

touchpad_synaptics_cfg() {
  err "You need root privilegies to perform it.
Manualy run 'sudo cp etc/X11/xorg.conf.d/70-synaptics.conf /etc/X11/xorg.conf.d/'
  "
}

crontab_cfg() {
  mkdir --parents "${OLD_VERSION_DIR}"
  crontab -l > "${OLD_VERSION_DIR}/crontab.cfg"
  cat crontab.cfg | crontab -
}

vim_cfg() {
  install_file "vim/vimrc" "${HOME}/.vimrc"
}

nvim_cfg() {
  install_file "nvim/init.vim" "${HOME}/.config/nvim/init.vim"
}

bash_cfg() {
  install_file "bash/bashrc" "${HOME}/.bashrc"
}

zsh_cfg() {
  install_file "zsh/zshrc" "${HOME}/.zshrc"
}

i3_cfg() {
  install_file "i3/config"    "${HOME}/.config/i3/config"
}

i3status_cfg() {
  install_file "i3status/config" "${HOME}/.config/i3status/config"
}

ssh_cfg() {
  install_file "ssh/config" "${HOME}/.ssh/config"
}

redshift_cfg() {
  install_file "redshift/redshift.conf" "${HOME}/.config/redshift.conf"
}

tmux_cfg() {
  install_file "tmux/tmux.conf" "${HOME}/.tmux.conf"
}

dunst_cfg() {
  install_file "dunst/dunstrc" "${HOME}/.config/dunst/dunstrc"
}

git_cfg() {
  install_file "git/gitconfig" "${HOME}/.gitconfig"
}

x() {
  install_file "x/Xmodmap" "${HOME}/.Xmodmap"
  install_file "x/xinitrc" "${HOME}/.xinitrc"
}

nogui() {
  init_env
  vim_cfg
  nvim_cfg
  tmux_cfg
  bash_cfg
  zsh_cfg
  ssh_cfg
  git_cfg
}

gui() {
  nogui

  x
  i3_cfg
  dunst_cfg
  redshift_cfg
  scripts
}

assert_src_dir

if [ -z "$*" ]; then
  echo "$(basename $0) <function> <arg> [<arg>...]" >&2
  exit 1
else
  "$@"
fi
