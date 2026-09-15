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
mkdir -p "$TEST_ROOT/linux-bin" "$TEST_ROOT/mac-bin"
printf '#!/bin/sh\nprintf "Linux\\n"\n' >"$TEST_ROOT/linux-bin/uname"
printf '#!/bin/sh\nprintf "Darwin\\n"\n' >"$TEST_ROOT/mac-bin/uname"
chmod +x "$TEST_ROOT/linux-bin/uname" "$TEST_ROOT/mac-bin/uname"
mkdir -p "$rime_home/.local/share/fcitx5/rime"
printf 'old Rime config\n' >"$rime_home/.local/share/fcitx5/rime/default.custom.yaml"
printf 'generated data\n' >"$rime_home/.local/share/fcitx5/rime/generated.txt"

env PATH="$TEST_ROOT/linux-bin:$PATH" HOME="$rime_home" "$REPO_ROOT/reset.sh" --backup-dir "$rime_backup" rime
assert_file_matches \
    "$REPO_ROOT/config/rime/default.custom.yaml" \
    "$rime_home/.local/share/fcitx5/rime/default.custom.yaml"
[[ "$(cat -- "$rime_home/.local/share/fcitx5/rime/generated.txt")" == "generated data" ]] ||
    fail "Rime merge removed an unmanaged file"
[[ "$(cat -- "$rime_backup/.local/share/fcitx5/rime/default.custom.yaml")" == "old Rime config" ]] ||
    fail "original Rime tree was not backed up"
env PATH="$TEST_ROOT/linux-bin:$PATH" HOME="$rime_home" "$REPO_ROOT/reset.sh" --backup-dir "$rime_backup" rime

# Exercise macOS destination selection on either host OS. Native BSD tools
# and the Squirrel app still need a real macOS smoke test.
mac_home="$TEST_ROOT/mac home"
mac_backup="$TEST_ROOT/mac backup"
mac_rime="$mac_home/Library/Rime"
mkdir -p "$mac_rime"
printf 'old Mac theme\n' >"$mac_rime/squirrel.custom.yaml"
printf 'local installation\n' >"$mac_rime/installation.yaml"
printf 'all:\n\t@touch rebuild-was-run\n' >"$mac_rime/Makefile"
env PATH="$TEST_ROOT/mac-bin:$PATH" HOME="$mac_home" \
    "$REPO_ROOT/rime.sh" --dry-run --backup-dir "$mac_backup"
[[ "$(cat "$mac_rime/squirrel.custom.yaml")" == "old Mac theme" ]] ||
    fail "Mac dry-run changed the theme"
[[ ! -e "$mac_backup" ]] || fail "Mac dry-run created a backup"
env PATH="$TEST_ROOT/mac-bin:$PATH" HOME="$mac_home" \
    "$REPO_ROOT/rime.sh" --backup-dir "$mac_backup"
assert_file_matches "$REPO_ROOT/config/rime/squirrel.custom.yaml" "$mac_rime/squirrel.custom.yaml"
assert_file_matches "$REPO_ROOT/config/rime/keytao.user.dict.yaml" "$mac_rime/keytao.user.dict.yaml"
[[ "$(cat "$mac_backup/Library/Rime/squirrel.custom.yaml")" == "old Mac theme" ]] ||
    fail "Mac theme was not backed up"
[[ "$(cat "$mac_rime/installation.yaml")" == "local installation" ]] ||
    fail "Mac installation state was changed"
[[ ! -e "$mac_home/.local/share/fcitx5" ]] || fail "Mac install used the Linux directory"
[[ ! -e "$mac_rime/rebuild-was-run" ]] || fail "Mac install invoked a Makefile"
env PATH="$TEST_ROOT/mac-bin:$PATH" HOME="$mac_home" \
    "$REPO_ROOT/rime.sh" --backup-dir "$mac_backup"

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

# Isolate detection from applications installed on the test host.
detect_bin="$TEST_ROOT/detect-bin"
detect_home="$TEST_ROOT/detect-home"
mkdir -p "$detect_bin"
for tool in bash dirname date find; do
    ln -s "$(command -v "$tool")" "$detect_bin/$tool"
done
cp "$TEST_ROOT/linux-bin/uname" "$detect_bin/uname"
output="$(env PATH="$detect_bin" HOME="$detect_home" "$REPO_ROOT/reset.sh" --dry-run)"
[[ "$output" == *"skip kitty:"* && "$output" == *"skip Rime:"* ]] ||
    fail "absent Linux applications were not skipped"
[[ ! -e "$detect_home" ]] || fail "automatic dry-run wrote into HOME"

mkdir -p "$detect_home/.config/kitty" "$detect_home/.local/share/fcitx5/rime"
output="$(env PATH="$detect_bin" HOME="$detect_home" "$REPO_ROOT/reset.sh" --dry-run)"
[[ "$output" == *"install $detect_home/.config/kitty/kitty.conf"* &&
   "$output" == *"merge $REPO_ROOT/config/rime -> $detect_home/.local/share/fcitx5/rime"* ]] ||
    fail "Linux configuration detection failed"
[[ ! -e "$detect_home/.config/kitty/kitty.conf" ]] || fail "kitty dry-run wrote configuration"
output="$(env PATH="$detect_bin" HOME="$detect_home" "$REPO_ROOT/reset.sh" core --dry-run)"
[[ "$output" != *kitty* && "$output" != *Rime* && "$output" != *rime* ]] ||
    fail "core unexpectedly included detected applications"

cp "$TEST_ROOT/mac-bin/uname" "$detect_bin/uname"
mkdir -p "$detect_home/Applications/kitty.app" "$detect_home/Library/Input Methods/Squirrel.app"
output="$(env PATH="$detect_bin" HOME="$detect_home" "$REPO_ROOT/reset.sh" all --dry-run)"
[[ "$output" == *"install $detect_home/.config/kitty/kitty.conf"* &&
   "$output" == *"merge $REPO_ROOT/config/rime -> $detect_home/Library/Rime"* ]] ||
    fail "macOS automatic destination selection failed"

printf '#!/bin/sh\nprintf "UnsupportedOS\\n"\n' >"$detect_bin/uname"
output="$(env PATH="$detect_bin" HOME="$detect_home" "$REPO_ROOT/reset.sh" --dry-run)"
[[ "$output" == *"skip Rime and kitty: unsupported platform UnsupportedOS"* ]] ||
    fail "unsupported platform was not skipped"

printf 'PASS: reset installer\n'
