.PHONY: all install

all:: install

install:: omz-init

omz-init:: omz-install omz-backup-original omz-link-setup

omz-install:
	# URL: https://github.com/ohmyzsh/ohmyzsh#basic-installation
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

omz-backup-original:
	mv ~/.oh-my-zsh/custom ~/.oh-my-zsh/custom.oh-my-zsh
	mv ~/.zshrc ~/.zshrc.oh-my-zsh

omz-link-setup:
	ln -s $(CURDIR)/oh-my-zsh/custom ~/.oh-my-zsh/custom
	ln -s $(CURDIR)/aliases ~/.aliases
	ln -s $(CURDIR)/zshrc ~/.zshrc

tmux-link-conf:
	ln -s $(CURDIR)/tmux.conf ~/.tmux.conf

vim-link-conf:
	ln -s $(CURDIR)/vimrc ~/.vimrc

vim-link-conf-minumal:
	ln -s $(CURDIR)/vimrc.minimal ~/.vimrc
