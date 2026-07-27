#!/usr/bin/env bash
set -Eeuo pipefail

readonly REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
TEST_ROOT="$(mktemp -d)"
readonly TEST_ROOT
trap 'rm -rf -- "$TEST_ROOT"' EXIT

fail() {
    printf 'FAIL: %s\n' "$*" >&2
    exit 1
}

assert_file_matches() {
    local expected="$1"
    local actual="$2"

    [[ -f "$actual" ]] || fail "missing file: $actual"
    cmp -s -- "$expected" "$actual" || fail "file differs: $actual"
}

test_home="$TEST_ROOT/home"
backup_root="$TEST_ROOT/backups"
mkdir -p "$test_home/.config/nvim"
printf 'local zsh config\n' >"$test_home/.zshrc"
printf 'keep me\n' >"$test_home/.config/nvim/local.lua"

(
    cd /
    HOME="$test_home" "$REPO_ROOT/reset.sh" --backup-dir "$backup_root"
)

assert_file_matches "$REPO_ROOT/config/top/toprc" "$test_home/.toprc"
assert_file_matches "$REPO_ROOT/config/zsh/zshrc" "$test_home/.zshrc"
assert_file_matches "$REPO_ROOT/config/nvim/init.lua" "$test_home/.config/nvim/init.lua"
assert_file_matches "$REPO_ROOT/config/tmux/tmux.conf" "$test_home/.tmux.conf"
assert_file_matches "$REPO_ROOT/config/tmux/tmux.conf.local" "$test_home/.tmux.conf.local"
[[ "$(cat -- "$test_home/.config/nvim/local.lua")" == "keep me" ]] ||
    fail "Neovim side file was changed"
[[ -L "$test_home/.init.lua" ]] || fail "missing Neovim compatibility link"
[[ "$(readlink -- "$test_home/.init.lua")" == "$test_home/.config/nvim/init.lua" ]] ||
    fail "incorrect Neovim compatibility link"
[[ "$(cat -- "$backup_root/.zshrc")" == "local zsh config" ]] ||
    fail "original zsh config was not backed up"

HOME="$test_home" "$REPO_ROOT/reset.sh" --backup-dir "$backup_root"

rime_home="$TEST_ROOT/rime-home"
rime_backup="$TEST_ROOT/rime-backup"
mkdir -p "$rime_home/.local/share/fcitx5/rime"
printf 'old Rime config\n' >"$rime_home/.local/share/fcitx5/rime/default.custom.yaml"
printf 'generated data\n' >"$rime_home/.local/share/fcitx5/rime/generated.txt"

HOME="$rime_home" "$REPO_ROOT/reset.sh" --backup-dir "$rime_backup" rime
assert_file_matches \
    "$REPO_ROOT/config/rime/default.custom.yaml" \
    "$rime_home/.local/share/fcitx5/rime/default.custom.yaml"
[[ "$(cat -- "$rime_home/.local/share/fcitx5/rime/generated.txt")" == "generated data" ]] ||
    fail "Rime merge removed an unmanaged file"
[[ "$(cat -- "$rime_backup/.local/share/fcitx5/rime/default.custom.yaml")" == "old Rime config" ]] ||
    fail "original Rime tree was not backed up"
HOME="$rime_home" "$REPO_ROOT/reset.sh" --backup-dir "$rime_backup" rime

dry_home="$TEST_ROOT/dry-home"
HOME="$dry_home" "$REPO_ROOT/reset.sh" --dry-run
[[ ! -e "$dry_home" ]] || fail "dry-run wrote into HOME"

invalid_home="$TEST_ROOT/invalid-home"
if HOME="$invalid_home" "$REPO_ROOT/reset.sh" top unknown >/dev/null 2>&1; then
    fail "unknown target unexpectedly succeeded"
fi
[[ ! -e "$invalid_home" ]] || fail "target validation was not atomic"

if HOME="$invalid_home" "$REPO_ROOT/reset.sh" dwm i3 >/dev/null 2>&1; then
    fail "conflicting window manager targets unexpectedly succeeded"
fi
[[ ! -e "$invalid_home" ]] || fail "target conflict wrote into HOME"

printf 'PASS: reset installer\n'
