#!/usr/bin/env bash

sudo chown xenpot:users /home/xenpot

cd ~;

source ~/.bashrc

echo "[start-tmux.sh] Installing node dependencies"
pushd ~/xenpot/frontend/
corepack install;
yarn install;
yarn run playwright install --with-deps chromium
popd
pushd ~/xenpot/exporter/
corepack install;
yarn install
yarn run playwright install --with-deps chromium
popd

tmux -2 new-session -d -s xenpot

tmux rename-window -t xenpot:0 'frontend watch'
tmux select-window -t xenpot:0
tmux send-keys -t xenpot 'cd xenpot/frontend' enter C-l
tmux send-keys -t xenpot 'yarn run watch' enter

tmux new-window -t xenpot:1 -n 'frontend shadow'
tmux select-window -t xenpot:1
tmux send-keys -t xenpot 'cd xenpot/frontend' enter C-l
tmux send-keys -t xenpot 'yarn run watch:app' enter

tmux new-window -t xenpot:2 -n 'frontend storybook'
tmux select-window -t xenpot:2
tmux send-keys -t xenpot 'cd xenpot/frontend' enter C-l
tmux send-keys -t xenpot 'yarn run watch:storybook' enter

tmux new-window -t xenpot:3 -n 'exporter'
tmux select-window -t xenpot:3
tmux send-keys -t xenpot 'cd xenpot/exporter' enter C-l
tmux send-keys -t xenpot 'rm -f target/app.js*' enter C-l
tmux send-keys -t xenpot 'clojure -M:dev:shadow-cljs watch main' enter

tmux split-window -v
tmux send-keys -t xenpot 'cd xenpot/exporter' enter C-l
tmux send-keys -t xenpot './scripts/wait-and-start.sh' enter

tmux new-window -t xenpot:4 -n 'backend'
tmux select-window -t xenpot:4
tmux send-keys -t xenpot 'cd xenpot/backend' enter C-l
tmux send-keys -t xenpot './scripts/start-dev' enter

tmux -2 attach-session -t xenpot
