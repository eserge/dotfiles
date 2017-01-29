#!/usr/bin/env sh

VIM_DIR=~/.vim/
VIM_COLORS_DIR=~/.vim/colors/
VIMRC_FILE=~/.vimrc
GITCONFIG_FILE=~/.gitconfig

echo "Creating vim dirs."
if ! [ -e "VIM_COLORS_DIR" ]; then
  mkdir -p "$VIM_COLORS_DIR"
fi

cd "$VIM_DIR"
echo "Downloading color schemes"
curl https://raw.githubusercontent.com/tomasr/molokai/master/colors/molokai.vim > colors/molokai.vim

echo "Installing Neobundle"
curl https://raw.githubusercontent.com/Shougo/neobundle.vim/master/bin/install.sh | sh
cd ..

echo "Cloning dotfiles configuration repository"
git clone https://github.com/eserge/dotfiles.git .dotfiles

echo "Linking .vimrc file"
if [ -e "$VIMRC_FILE" ]; then
  mv "$VIMRC_FILE" ~/.vimrc.back-`date +"%Y-%m-%d"`
fi
ln -s ~/.dotfiles/vim/_vimrc ~/.vimrc

echo "Linking .gitconfig file"
if [ -e "$GITCONFIG_FILE" ]; then
  mv "$GITCONFIG_FILE" ~/.gitconfigmachine
else
  touch .gitconfigmachine
fi
ln -s ~/.dotfiles/git/_gitconfig ~/.gitconfig

echo "Linking Emacs (Spacemacs) configuration"
ln -s ~/.dotfiles/.spacemacs ~/.spacemacs

echo "Done."
