#!/bin/bash


java -jar ./scheme2ddl-2.4.3-SNAPSHOT.jar

sudo cp -r ~/.vim/bundle ~/vimbackup/ 
sudo cp -r ~/.vim/autoload/ ~/vimbackup/ 
sudo cp -r ~/.vim/ftplugin/ ~/vimbackup/ 

git checkout develop
git add .
git commit -m "backup..."
git push -u origin develop

