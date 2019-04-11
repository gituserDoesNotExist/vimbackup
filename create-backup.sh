#!/bin/bash

sudo cp -r ~/.vim/bundle ~/vimbackup/ 
sudo cp -r ~/.vim/autoload/ ~/vimbackup/ 
sudo cp -r ~/.vim/ftplugin/ ~/vimbackup/ 

git add .
git commit -m "backup..."
git push

