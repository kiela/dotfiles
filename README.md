dotfiles
========

Personal configuration for zsh (oh-my-zsh), git, vim, tmux and a set of
small helper scripts.

Installation
------------

The default target installs oh-my-zsh, backs up its stock `custom/` and
`.zshrc`, links this repo's zsh setup and puts `bin/` on `PATH` as
`~/bin` (several git aliases depend on the scripts there):

    make install

All targets are idempotent - re-running them is safe. Optional targets:

    make git-link-conf      # ~/.gitconfig, ~/.gitignore, ~/.gitcommitmsg
    make ssh-link-conf      # ~/.ssh/config
    make tmux-link-conf     # ~/.tmux.conf
    make vim-link-conf      # ~/.vimrc (or vim-link-conf-minimal)
    make ruby-link-conf     # ~/.gemrc, ~/.irbrc, ~/.pryrc, ~/.rvmrc
    make erlang-link-conf   # ~/.erlang, ~/.erlang-hist.config, ~/.kerlrc
    make yamllint-link-conf # ~/.config/yamllint/config

Layout
------

| Path | Purpose |
| --- | --- |
| `aliases/` | Alias files, one per tool, loaded by `aliases/_load` |
| `bin/` | Helper scripts (`git-url`, `cert`, `spark`, `2048`, ...) |
| `oh-my-zsh/custom/` | Custom oh-my-zsh plugins and the `heimdall` theme |
| `zshrc`, `oh-my-zsh.rc` | Shell entry points |
| `gitconfig`, `gitconfig.minimal` | Full and fresh-machine git setups |
| `vimrc`, `vimrc.minimal`, `vim/` | Vim setup |

New files dropped into `aliases/` are picked up automatically; names
starting with `_` are reserved for the loader and helpers.

Per-directory configuration (dirrc)
-----------------------------------

The `dirrc` plugin loads `.aliases`, `.env` and `.dirrc` files when
entering a directory, and shows `.links`, `.msg` and `.todo` files.
Because those files execute code, a directory has to be allowed first:

    dirrc-trust [dir]     # allow (stored in ~/.dirrc_trusted)
    dirrc-untrust [dir]   # revoke

`$HOME` and `~/.aliases` are always trusted.

Local overrides
---------------

Machine-specific zsh configuration uses two hooks, both sourced if present:

- `~/.zshrc.local` — sourced *before* oh-my-zsh loads. Put `plugins+=(...)`,
  `ZSH_*` knobs and zstyles here.
- `~/.zshrc.local.post` — sourced *after* oh-my-zsh loads. Put overrides that
  must win over oh-my-zsh's own settings here (aliases, `PROMPT`, keybindings);
  they would be clobbered if placed in `~/.zshrc.local`.
