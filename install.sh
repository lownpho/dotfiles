how do#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="$HOME"
ALL_PACKAGES=(bash nvim vim tmux vscode)

usage() {
  echo "Usage: $0 [options] [package...]"
  echo ""
  echo "Options:"
  echo "  -n, --dry-run   Preview changes without applying them"
  echo "  -D, --unstow    Remove symlinks instead of creating them"
  echo "  -h, --help      Show this help"
  echo ""
  echo "If no packages are specified, all packages are stowed: ${ALL_PACKAGES[*]}"
}

DRY_RUN=false
UNSTOW=false
PACKAGES=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    -n|--dry-run) DRY_RUN=true; shift ;;
    -D|--unstow)  UNSTOW=true;  shift ;;
    -h|--help)    usage; exit 0 ;;
    -*) echo "Unknown option: $1" >&2; usage; exit 1 ;;
    *)  PACKAGES+=("$1"); shift ;;
  esac
done

if [[ ${#PACKAGES[@]} -eq 0 ]]; then
  PACKAGES=("${ALL_PACKAGES[@]}")
fi

if ! command -v stow &>/dev/null; then
  echo "Error: 'stow' is not installed or not in PATH." >&2
  echo "Install it with your package manager, e.g.: sudo apt install stow" >&2
  exit 1
fi

STOW_FLAGS=(-d "$DOTFILES_DIR" -t "$TARGET")
$DRY_RUN  && STOW_FLAGS+=(-n -v)
$UNSTOW   && STOW_FLAGS+=(-D)

VSCODE_EXTENSIONS=(
  xaver.clang-format
  ms-python.python
  ms-python.black-formatter
  foxundermoon.shell-format
  esbenp.prettier-vscode
  redhat.vscode-yaml
  mshr-h.veriloghdl
)

for pkg in "${PACKAGES[@]}"; do
  if [[ ! -d "$DOTFILES_DIR/$pkg" ]]; then
    echo "Warning: package '$pkg' not found, skipping." >&2
    continue
  fi
  echo "  stow $pkg"
  stow "${STOW_FLAGS[@]}" "$pkg"
done

if [[ " ${PACKAGES[*]} " == *" vscode "* ]] && ! $UNSTOW; then
  if command -v code &>/dev/null; then
    echo "  installing VSCode extensions..."
    for ext in "${VSCODE_EXTENSIONS[@]}"; do
      $DRY_RUN && echo "    code --install-extension $ext" || code --install-extension "$ext" --force 2>/dev/null
    done
  else
    echo "Warning: 'code' not in PATH, skipping VSCode extensions." >&2
  fi
fi
