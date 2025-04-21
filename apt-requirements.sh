#!/bin/bash

sudo apt install libgtk-4-dev libadwaita-1-dev git blueprint-compiler gettext libxml2-utils

echo 'export GDK_DEBUG=gl-disable-gles ghostty' >>~/.bashrc

curl -L https://ziglang.org/download/0.14.0/zig-linux-x86_64-0.14.0.tar.xz | tar -xJ && cd zig-linux-x86_64-0.14.0 && ./install

cd ..

git clone https://github.com/ghostty-org/ghostty

cd ghostty

zig build -p $HOME/.local -Doptimize=ReleaseFast

# detect if the $HOME/.local/bin is in the PATH
if ! echo "$PATH" | grep -q "$HOME/.local/bin"; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >>~/.bashrc
fi

echo 'Ghostty has been installed to $HOME/.local/bin/. use "ghostty" to start it.'
