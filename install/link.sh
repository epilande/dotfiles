#!/bin/bash

DOTFILES=$HOME/.dotfiles

echo "Creating symlinks"

for file in **/*.symlink ; do
  target="$HOME/.$( basename $file ".symlink" )"
  echo "creating symlink for $file"
  ln -s $DOTFILES/$file $target
done
