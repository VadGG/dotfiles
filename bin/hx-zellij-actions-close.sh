#!/usr/bin/env bash
cleanup_and_reload() {
    zellij action toggle-floating-panes
    zellij action write 27 # send <Escape> key
    zellij action write-chars ":reload-all"
    zellij action write 13 # send <Enter> key
    zellij action toggle-floating-panes
    zellij action close-pane
}

cleanup_and_reload
