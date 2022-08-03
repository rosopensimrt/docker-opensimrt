#!/usr/bin/env bash

cd /nvim

wget https://github.com/neovim/neovim/releases/download/v0.7.2/nvim-linux64.tar.gz
tar -xvf nvim-linux64.tar.gz

chmod a+x /nvim/nvim-linux64/bin/nvim
ln -s /nvim/nvim-linux64/bin/nvim /bin/nv

nv +PlugUpdate +qall



