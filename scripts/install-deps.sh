#!/usr/bin/env bash
set -euo pipefail

has() { command -v "$1" &>/dev/null; }

warn() { echo "  [warn] $*" >&2; }

if   has apt-get; then PM=apt
elif has brew;    then PM=brew
else echo "Error: unsupported OS (expected Ubuntu/Debian or macOS with Homebrew)." >&2; exit 1
fi

install() {
    case "$PM" in
        apt)  sudo apt-get install -y "$@" ;;
        brew) brew install "$@" ;;
    esac
}

echo "==> [core] stow git"
install stow git

echo "==> [tmux] tmux"
install tmux

echo "==> [vim] vim"
install vim

echo "==> [nvim] neovim gcc jq"
case "$PM" in
    apt)  install neovim gcc jq ;;
    brew) install neovim jq ;;
esac

echo "==> [nvim] clang-format"
case "$PM" in
    apt)  install clang-format ;;
    brew) install clang-format ;;
esac

echo "==> [nvim] shfmt"
install shfmt

echo "==> [nvim] stylua"
if ! has stylua; then
    case "$PM" in
        brew) install stylua ;;
        apt)
            if has cargo; then
                cargo install stylua
            else
                warn "stylua not found and cargo is not available."
                warn "Install Rust (https://rustup.rs) then 'cargo install stylua',"
                warn "or Mason will install it for Neovim via :MasonInstall stylua."
            fi
            ;;
    esac
fi

echo "==> [nvim] python3 + black"
case "$PM" in
    apt)  install python3 python3-pip ;;
    brew) install python3 ;;
esac
if has pip3; then
    pip3 install --user black
elif has pip; then
    pip install --user black
else
    warn "pip not found; run 'pip3 install black' after installing python3-pip."
fi

echo "==> [nvim] nodejs + prettierd"
if ! has node; then
    case "$PM" in
        apt)  install nodejs npm ;;
        brew) install node ;;
    esac
fi
if ! has prettierd; then
    if has npm; then
        npm install -g @fsouza/prettierd || sudo npm install -g @fsouza/prettierd
    else
        warn "npm not found; install nodejs/npm then: npm install -g @fsouza/prettierd"
    fi
fi

echo "==> [vscode] verible (Verilog/SV linter and formatter)"
if ! has verible-verilog-format; then
    case "$PM" in
        brew) install verible ;;
        apt)  warn "verible not in apt repos. Download a release binary from:"
              warn "  https://github.com/chipsalliance/verible/releases"
              warn "(Mason will install it automatically for Neovim LSP.)" ;;
    esac
fi

echo ""
echo "Done. Run ./scripts/install.sh to symlink dotfiles into \$HOME."
