#!/usr/bin/env bash

sudo chown xenpot:users /home/xenpot

cd ~;

source ~/.bashrc

set -e;

echo "[start-tmux.sh] Installing node dependencies"
pushd ~/xenpot/exporter/
yarn install
popd

tmux -2 new-session -d -s xenpot

tmux rename-window -t xenpot:0 'exporter'
tmux select-window -t xenpot:0
tmux send-keys -t xenpot 'cd xenpot/exporter' enter C-l
tmux send-keys -t xenpot 'rm -f target/app.js*' enter C-l
tmux send-keys -t xenpot 'clojure -M:dev:shadow-cljs watch main' enter

tmux split-window -v
tmux send-keys -t xenpot 'cd xenpot/exporter' enter C-l
tmux send-keys -t xenpot './scripts/wait-and-start.sh' enter

tmux new-window -t xenpot:1 -n 'backend'
tmux select-window -t xenpot:1
tmux send-keys -t xenpot 'cd xenpot/backend' enter C-l
tmux send-keys -t xenpot './scripts/start-dev' enter

tmux -2 attach-session -t xenpot
