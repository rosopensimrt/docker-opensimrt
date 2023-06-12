#!/usr/bin/env bash
SOURCEVIM=/nvim
mkdir -p ~/.config/nvim
mkdir -p ~/.vim/autoload
cp $SOURCEVIM/init.vim ~/.config/nvim
cp $SOURCEVIM/.vimrc ~/

cp $SOURCEVIM/plug.vim ~/.vim/autoload
nv -S vim-plug.list
nv +PlugUpdate +qall

python3 ~/.vim/plugged/YouCompleteMe/install.py --clangd-completer


