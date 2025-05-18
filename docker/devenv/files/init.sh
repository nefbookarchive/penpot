#!/usr/bin/env bash

cp /root/.bashrc /home/xenpot/.bashrc
cp /root/.vimrc /home/xenpot/.vimrc
cp /root/.tmux.conf /home/xenpot/.tmux.conf
chown -R xenpot:users /home/xenpot

set -e
nginx
tail -f /dev/null
