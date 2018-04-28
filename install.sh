#!/usr/bin/env bash

set -e -x

HOME_TMP="$HOME/tmp"
OLD_VERSION_DIR="$HOME_TMP/old_version"
BIN_DIR="$HOME/bin"

init_env() {
    mkdir --parents "$HOME_TMP"
    mkdir --parents "$OLD_VERSION_DIR"
    mkdir --parents "$BIN_DIR"

    if [[ -d "$HOME/Downloads" ]]; then
        rm --recursive "$HOME/Downloads"
        ln --symbolic "$HOME_TMP" "$HOME/Downloads"
    fi
}

bin() {
    install_file "other/saveit" "$HOME/bin/saveit"
    install_file "other/screenshot.sh" "$HOME/bin/screenshot.sh"
    install_file "other/amount" "$HOME/bin/amount"
}

install_file() {
    local new=$1
    local old=$2

    if [[ -f "$old" ]]; then
        if ! $(diff -q "$new" "$old" >&2); then
            mkdir --parent "$OLD_VERSION_DIR"
            cp "$old" "$OLD_VERSION_DIR/$(basename $old)"
        fi
    fi
    cp $new $old
}

crontab_cfg() {
    mkdir --parent "$OLD_VERSION_DIR"
    crontab -l > "$OLD_VERSION_DIR/crontab.cfg"
    cat crontab.cfg | crontab -
}

vim_cfg() {
    install_file vimrc "$HOME/.vimrc"
}

bash_cfg() {
    install_file bash/bashrc "$HOME/.bashrc"
}

i3_cfg() {
    mkdir --parents "$HOME/.i3"
    install_file i3/config      "$HOME/.i3/config"
    install_file i3/prepare.sh  "$HOME/.i3/prepare.sh"
    install_file i3/status.conf "$HOME/.i3/status.conf"
}

ssh_cfg() {
    mkdir --parents "$HOME/.ssh"
    install_file ssh/config "$HOME/.ssh/config"
}

tmux_cfg() {
    install_file tmux.conf "$HOME/.tmux.conf"
}

dunst_cfg() {
    mkdir --parents "$HOME/.config/dunst"
    install_file "dunst/dunstrc" "$HOME/.config/dunst/dunstrc"
}

nogui() {
    init_env
    bin
    vim_cfg
    bash_cfg
    ssh_cfg
    tmux_cfg
}

gui() {
    nogui

    crontab_cfg
    i3_cfg
    dunst_cfg
}

if [ -z "$*" ]; then
    echo "$(basename $0) <function> <arg> [<arg>...]" >&2
    exit 1
else
    "$@"
fi
