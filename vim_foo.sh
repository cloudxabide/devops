#!/bin/bash

# Cleanup for VIM
mkdir -p ~/.vim/{autoload,bundle,plugins,tmp}

cat << EOF > ~/.vimrc
" ================ Indentation ======================

set autoindent
set smartindent
set smarttab
set shiftwidth=2
set softtabstop=2
set tabstop=2
set expandtab

filetype plugin on
filetype indent on

" Move *.swp files to central location
set directory^=$HOME/.vim/tmp//
EOF

exit 0

blah() {
  curl -o ~/.vim/plugins/yaml.vim https://www.vim.org/scripts/download_script.php?src_id=2249
  echo "au! BufNewFile,BufReadPost *.{yaml,yml} set filetype=yaml foldmethod=indent so ~/.vim/plugins/yaml.vim
  autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab" > ~/.vimrc

  #  If you want to use Pathogen
  curl -o ~/.vim/autoload/pathogen.vim https://raw.githubusercontent.com/tpope/vim-pathogen/master/autoload/pathogen.vim
  sed -i '' '1i\
    execute pathogen#infect()\
    ' ~/.vimrc
  cd ~/.vim/bundle
  git clone https://github.com/tpope/vim-surround
}
