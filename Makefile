.PHONY: all install omz-init omz-install omz-backup-original omz-link-setup \
	bin-link git-link-conf ssh-link-conf \
	tmux-link-conf vim-link-conf vim-link-conf-minimal

all:: install

install:: omz-init bin-link

omz-init:: omz-install omz-backup-original omz-link-setup

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

# zshrc puts ~/bin on PATH and several git aliases call scripts from it
# (trim, spark, git-prune-local, git-all-repos), so link it by default.
bin-link:
	ln -sfn $(CURDIR)/bin ~/bin

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
