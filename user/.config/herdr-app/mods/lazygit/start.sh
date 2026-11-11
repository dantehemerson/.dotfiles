#!/bin/sh
# The core starts headless (usually 200x120). Let the popup attach and resize
# the PTY before LazyGit draws its first frame, rather than drawing then
# clipping/reflowing it. Bound the wait for an unchanged size or no viewer.
initial=$(stty size 2>/dev/null) || exec lazygit "$@"
i=0
while [ "$i" -lt 8 ]; do
    sleep 0.01
    size=$(stty size 2>/dev/null) || break
    if [ "$size" != "$initial" ]; then
        # Let a second layout pass settle before starting the full-screen UI.
        sleep 0.02
        break
    fi
    i=$((i + 1))
done
exec lazygit "$@"
