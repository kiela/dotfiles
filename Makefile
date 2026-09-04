.PHONY: all install omz-init omz-install omz-backup-original omz-link-setup \
	tmux-link-conf vim-link-conf vim-link-conf-minimal

all:: install

install:: omz-init

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

tmux-link-conf:
	ln -sfn $(CURDIR)/tmux.conf ~/.tmux.conf

vim-link-conf:
	ln -sfn $(CURDIR)/vimrc ~/.vimrc

vim-link-conf-minimal:
	ln -sfn $(CURDIR)/vimrc.minimal ~/.vimrc
