# Dotfiles

My personal configs, managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Setup

```bash
git clone <repo> ~/Workspace/dotfiles
cd ~/Workspace/dotfiles
./install.sh
```

## Usage

```bash
./install.sh              # stow everything
./install.sh nvim bash    # stow specific packages
./install.sh -n           # dry-run
./install.sh -D nvim      # unstow
```

## Packages

- `bash/` — `.bashrc`
- `nvim/` — `.config/nvim/` (Lua, `vim.pack`)
- `vim/` — `.vimrc` (fallback)
- `tmux/` — `.tmux.conf` (prefix: `C-a`)
