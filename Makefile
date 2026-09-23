.PHONY: all install omz-init omz-install omz-backup-original omz-link-setup \
	bin-link git-link-conf ssh-link-conf \
	tmux-link-conf vim-link-conf vim-link-conf-minimal \
	yamllint-link-conf check-shell

all:: install

install:: check-shell omz-init bin-link

omz-init:: omz-install omz-backup-original omz-link-setup

# Everything here is zsh-only, so refuse to install rather than leave a
# half-working setup behind. Ask the directory service first (macOS), then
# /etc/passwd (Linux), and fall back to $SHELL.
check-shell:
	@zsh_bin=$$(command -v zsh); \
	if [ -z "$$zsh_bin" ]; then \
	  echo "ERROR: zsh is not installed; install it, then re-run make install" >&2; \
	  exit 1; \
	fi; \
	login_shell=$$(dscl . -read ~/ UserShell 2>/dev/null | awk '{print $$2}'); \
	if [ -z "$$login_shell" ]; then \
	  login_shell=$$(getent passwd "$$(id -un)" 2>/dev/null | cut -d: -f7); \
	fi; \
	if [ -z "$$login_shell" ]; then login_shell="$$SHELL"; fi; \
	case "$$login_shell" in \
	  */zsh) echo "check-shell: login shell is $$login_shell";; \
	  *) echo "ERROR: login shell is $$login_shell, not zsh" >&2; \
	     echo "ERROR: run 'chsh -s $$zsh_bin', start a new session, then re-run make install" >&2; \
	     exit 1;; \
	esac

omz-install:
	# URL: https://github.com/ohmyzsh/ohmyzsh#basic-installation
	[ -d ~/.oh-my-zsh ] || sh -c "$$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

omz-backup-original:
	[ -e ~/.oh-my-zsh/custom.oh-my-zsh ] || mv ~/.oh-my-zsh/custom ~/.oh-my-zsh/custom.oh-my-zsh
	[ -e ~/.zshrc.oh-my-zsh ] || mv ~/.zshrc ~/.zshrc.oh-my-zsh

omz-link-setup:
	ln -sfn $(CURDIR)/oh-my-zsh/custom ~/.oh-my-zsh/custom
	ln -sfn $(CURDIR)/aliases ~/.aliases
	ln -sfn $(CURDIR)/zshrc ~/.zshrc
	ln -sfn $(CURDIR)/oh-my-zsh.rc ~/.oh-my-zsh.rc

# zshrc puts ~/bin on PATH and several git aliases call scripts from it
# (trim, spark, git-prune-local, git-all-repos), so link it by default.
# Link each script into ~/bin rather than symlinking the whole directory:
# `ln -sfn bin ~/bin` would nest into an existing ~/bin, creating ~/bin/bin
# and leaving the scripts off PATH. First drop a ~/bin that is our own
# whole-dir symlink from an earlier run, then link the scripts individually.
bin-link:
	@if [ -L ~/bin ] && [ "`readlink ~/bin`" = "$(CURDIR)/bin" ]; then rm ~/bin; fi
	mkdir -p ~/bin
	for f in $(CURDIR)/bin/*; do ln -sf "$$f" ~/bin/; done

git-link-conf:
	ln -sf $(CURDIR)/gitconfig ~/.gitconfig
	ln -sf $(CURDIR)/gitignore ~/.gitignore
	ln -sf $(CURDIR)/gitcommitmsg ~/.gitcommitmsg

ssh-link-conf:
	mkdir -p ~/.ssh
	ln -sf $(CURDIR)/ssh/config ~/.ssh/config

tmux-link-conf:
	ln -sfn $(CURDIR)/tmux.conf ~/.tmux.conf

vim-link-conf:
	ln -sfn $(CURDIR)/vimrc ~/.vimrc

vim-link-conf-minimal:
	ln -sfn $(CURDIR)/vimrc.minimal ~/.vimrc

# Opt-in language-tooling configs (not part of the default install).
yamllint-link-conf:
	mkdir -p ~/.config/yamllint
	ln -sf $(CURDIR)/yamllint ~/.config/yamllint/config
