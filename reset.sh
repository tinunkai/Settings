#!/usr/bin/env bash
set -Eeuo pipefail

readonly REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

DRY_RUN=0
BACKUP_ROOT=""
targets=()

usage() {
    cat <<'EOF'
Usage: ./reset.sh [options] [target ...]

Install the core terminal configuration. With no targets, this installs:
top, zsh, nvim, and tmux.

Targets:
  core, all  Install all core targets
  top        Install ~/.toprc
  zsh        Install ~/.zshrc
  nvim       Install Neovim's init.lua and ~/.init.lua compatibility link
  tmux       Install ~/.tmux.conf and ~/.tmux.conf.local
  vim        Install ~/.vimrc
  mycli      Install ~/.myclirc
  imv        Install ~/.config/imv/config
  x11        Install ~/.Xresources and ~/.xprofile
  dwm        Install the common X11 files and the dwm ~/.xinitrc
  i3         Install the common X11 files and the i3 ~/.xinitrc
  river      Install ~/.config/river/init
  rime       Merge Rime files into the fcitx5 user data directory

Options:
  -n, --dry-run        Print changes without writing anything
  --backup-dir DIR     Store replaced files under DIR
  -h, --help           Show this help

System package setup remains available separately through ubuntu.sh.
EOF
}

while (($#)); do
    case "$1" in
        -n|--dry-run)
            DRY_RUN=1
            ;;
        --backup-dir)
            (($# >= 2)) || {
                printf 'error: --backup-dir requires a directory\n' >&2
                exit 2
            }
            BACKUP_ROOT="$2"
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        --)
            shift
            targets+=("$@")
            break
            ;;
        -*)
            printf 'error: unknown option: %s\n' "$1" >&2
            usage >&2
            exit 2
            ;;
        *)
            targets+=("$1")
            ;;
    esac
    shift
done

if ((${#targets[@]} == 0)); then
    targets=(core)
fi

has_dwm=0
has_i3=0
for target in "${targets[@]}"; do
    case "$target" in
        core|all|top|zsh|nvim|tmux|vim|mycli|imv|x11|river|rime)
            ;;
        dwm)
            has_dwm=1
            ;;
        i3)
            has_i3=1
            ;;
        *)
            printf 'error: unknown target: %s\n' "$target" >&2
            usage >&2
            exit 2
            ;;
    esac
done

if [[ "$has_dwm" == "1" && "$has_i3" == "1" ]]; then
    printf 'error: dwm and i3 both install ~/.xinitrc; choose one\n' >&2
    exit 2
fi

export DRY_RUN
if [[ -n "$BACKUP_ROOT" ]]; then
    export BACKUP_ROOT
fi

# shellcheck source=scripts/lib/install.sh
source "$REPO_ROOT/scripts/lib/install.sh"

install_top() {
    install_file "$REPO_ROOT/config/top/toprc" "$HOME/.toprc"
}

install_zsh() {
    install_file "$REPO_ROOT/config/zsh/zshrc" "$HOME/.zshrc"
}

install_nvim() {
    local init_path="$HOME/.config/nvim/init.lua"

    install_file "$REPO_ROOT/config/nvim/init.lua" "$init_path"
    install_symlink "$init_path" "$HOME/.init.lua"
}

install_tmux() {
    install_file "$REPO_ROOT/config/tmux/tmux.conf" "$HOME/.tmux.conf"
    install_file "$REPO_ROOT/config/tmux/tmux.conf.local" "$HOME/.tmux.conf.local"
}

install_vim() {
    install_file "$REPO_ROOT/config/vim/vimrc" "$HOME/.vimrc"
}

install_mycli() {
    install_file "$REPO_ROOT/config/mycli/myclirc" "$HOME/.myclirc"
}

install_imv() {
    install_file "$REPO_ROOT/config/imv/config" "$HOME/.config/imv/config"
}

install_x11() {
    install_file "$REPO_ROOT/config/x11/Xresources" "$HOME/.Xresources"
    install_file "$REPO_ROOT/config/x11/xprofile" "$HOME/.xprofile"
}

install_dwm() {
    install_x11
    install_file "$REPO_ROOT/config/x11/dwm.xinitrc" "$HOME/.xinitrc" 0755
}

install_i3() {
    install_x11
    install_file "$REPO_ROOT/config/x11/i3.xinitrc" "$HOME/.xinitrc" 0755
}

install_river() {
    install_file "$REPO_ROOT/config/river/init" "$HOME/.config/river/init" 0755
}

install_rime() {
    local rime_home="$HOME/.local/share/fcitx5/rime"

    install_tree_merge "$REPO_ROOT/config/rime" "$rime_home"
    if [[ -f "$rime_home/Makefile" ]]; then
        log "rebuild Rime data"
        run make -C "$rime_home"
    else
        log "no Makefile in $rime_home; skipping rebuild"
    fi
}

install_target() {
    case "$1" in
        top)
            install_top
            ;;
        zsh)
            install_zsh
            ;;
        nvim)
            install_nvim
            ;;
        tmux)
            install_tmux
            ;;
        vim)
            install_vim
            ;;
        mycli)
            install_mycli
            ;;
        imv)
            install_imv
            ;;
        x11)
            install_x11
            ;;
        dwm)
            install_dwm
            ;;
        i3)
            install_i3
            ;;
        river)
            install_river
            ;;
        rime)
            install_rime
            ;;
        core|all)
            install_top
            install_zsh
            install_nvim
            install_tmux
            ;;
        *)
            die "unknown target: $1"
            ;;
    esac
}

for target in "${targets[@]}"; do
    install_target "$target"
done

print_backup_summary
