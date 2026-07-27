#!/usr/bin/env bash
set -Eeuo pipefail

readonly REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
readonly DOOM_CONFIG="$REPO_ROOT/config/doom"

[[ -d "$DOOM_CONFIG" ]] || {
    printf 'error: Doom configuration is missing: %s\n' "$DOOM_CONFIG" >&2
    exit 1
}

command -v git >/dev/null || {
    printf 'error: git is required\n' >&2
    exit 1
}

readonly TEMP_ROOT="$(mktemp -d)"
trap 'rm -rf -- "$TEMP_ROOT"' EXIT

git clone --depth 1 https://github.com/hlissner/doom-emacs "$TEMP_ROOT/emacs.d"

# shellcheck source=scripts/lib/install.sh
source "$REPO_ROOT/scripts/lib/install.sh"

backup_target "$HOME/.emacs.d"
run mv -- "$TEMP_ROOT/emacs.d" "$HOME/.emacs.d"
"$HOME/.emacs.d/bin/doom" install
install_tree_merge "$DOOM_CONFIG" "$HOME/.doom.d"
"$HOME/.emacs.d/bin/doom" sync
print_backup_summary
