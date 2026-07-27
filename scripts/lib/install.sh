#!/usr/bin/env bash

if [[ -n "${SETTINGS_INSTALL_LIB_LOADED:-}" ]]; then
    return 0
fi
readonly SETTINGS_INSTALL_LIB_LOADED=1

: "${REPO_ROOT:?REPO_ROOT must point to the Settings repository}"
: "${HOME:?HOME must be set}"

if [[ "$HOME" == "/" ]]; then
    printf 'error: refusing to install with HOME=/\n' >&2
    exit 1
fi

DRY_RUN="${DRY_RUN:-0}"
BACKUP_ROOT="${BACKUP_ROOT:-$HOME/.local/state/settings-backups/$(date +%Y%m%d-%H%M%S-%N)}"
BACKUP_USED=0

log() {
    printf '[settings] %s\n' "$*"
}

die() {
    printf '[settings] error: %s\n' "$*" >&2
    exit 1
}

run() {
    if [[ "$DRY_RUN" == "1" ]]; then
        printf '[settings] dry-run:'
        printf ' %q' "$@"
        printf '\n'
        return 0
    fi

    "$@"
}

backup_target() {
    local target="$1"
    local relative backup

    if [[ ! -e "$target" && ! -L "$target" ]]; then
        return 0
    fi

    case "$target" in
        "$HOME")
            die "refusing to replace HOME itself"
            ;;
        "$HOME"/*)
            relative="${target#"$HOME"/}"
            ;;
        *)
            die "backup target is outside HOME: $target"
            ;;
    esac

    backup="$BACKUP_ROOT/$relative"
    if [[ -e "$backup" || -L "$backup" ]]; then
        die "backup already exists: $backup"
    fi

    log "backup $target -> $backup"
    run mkdir -p -- "$(dirname -- "$backup")"
    run mv -- "$target" "$backup"
    BACKUP_USED=1
}

install_file() {
    local source="$1"
    local target="$2"
    local mode="${3:-0644}"
    local current_mode

    [[ -f "$source" ]] || die "missing source file: $source"

    if [[ -f "$target" && ! -L "$target" ]] && cmp -s -- "$source" "$target"; then
        current_mode="$(stat -c '%a' -- "$target")"
        if [[ "$current_mode" == "${mode#0}" ]]; then
            log "unchanged $target"
            return 0
        fi
    fi

    backup_target "$target"
    log "install $target"
    run mkdir -p -- "$(dirname -- "$target")"
    run install -m "$mode" -- "$source" "$target"
}

install_symlink() {
    local link_target="$1"
    local link_path="$2"

    if [[ -L "$link_path" && "$(readlink -- "$link_path")" == "$link_target" ]]; then
        log "unchanged $link_path"
        return 0
    fi

    backup_target "$link_path"
    log "link $link_path -> $link_target"
    run mkdir -p -- "$(dirname -- "$link_path")"
    run ln -s -- "$link_target" "$link_path"
}

tree_is_current() {
    local source="$1"
    local target="$2"
    local source_path relative target_path

    [[ -d "$target" ]] || return 1

    while IFS= read -r -d '' source_path; do
        relative="${source_path#"$source"/}"
        target_path="$target/$relative"

        if [[ -L "$source_path" ]]; then
            [[ -L "$target_path" ]] || return 1
            [[ "$(readlink -- "$source_path")" == "$(readlink -- "$target_path")" ]] || return 1
        elif [[ -d "$source_path" ]]; then
            [[ -d "$target_path" ]] || return 1
        elif [[ -f "$source_path" ]]; then
            [[ -f "$target_path" && ! -L "$target_path" ]] || return 1
            cmp -s -- "$source_path" "$target_path" || return 1
        fi
    done < <(find "$source" -mindepth 1 -print0)
}

backup_copy_target() {
    local target="$1"
    local relative backup

    case "$target" in
        "$HOME")
            die "refusing to back up HOME itself"
            ;;
        "$HOME"/*)
            relative="${target#"$HOME"/}"
            ;;
        *)
            die "backup target is outside HOME: $target"
            ;;
    esac

    backup="$BACKUP_ROOT/$relative"
    if [[ -e "$backup" || -L "$backup" ]]; then
        die "backup already exists: $backup"
    fi

    log "backup $target -> $backup"
    run mkdir -p -- "$(dirname -- "$backup")"
    run cp -a -- "$target" "$backup"
    BACKUP_USED=1
}

install_tree_merge() {
    local source="$1"
    local target="$2"

    [[ -d "$source" ]] || die "missing source directory: $source"

    if tree_is_current "$source" "$target"; then
        log "unchanged $target"
        return 0
    fi

    if [[ -e "$target" || -L "$target" ]]; then
        [[ -d "$target" && ! -L "$target" ]] || die "tree target is not a directory: $target"
        backup_copy_target "$target"
    fi

    log "merge $source -> $target"
    run mkdir -p -- "$target"
    run cp -a -- "$source/." "$target/"
}

print_backup_summary() {
    if [[ "$BACKUP_USED" == "1" ]]; then
        if [[ "$DRY_RUN" == "1" ]]; then
            log "replaced files would be saved under $BACKUP_ROOT"
        else
            log "replaced files were saved under $BACKUP_ROOT"
        fi
    fi
}
