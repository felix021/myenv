#!/bin/bash

set -x

cd `dirname $0`

here=`pwd`

function color_text()
{
    echo "\\x1b[33;44m$1\\x1b[0m"
}

echo "export PATH=\$PATH:$here/bin" >> ~/.bashrc
echo "source $here/.bashrc" >> ~/.bashrc
source $here/.bashrc

if [ -e ~/.vimrc ]; then
    mv ~/.vimrc ~/.vimrc.bak
    echo "original .vimrc moved to ~/.vimrc.bak"
fi

ln -s $here/.vimrc ~/.vimrc

source $here/git_alias
