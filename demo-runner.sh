#!/bin/bash


function delayAndClear() {
    sleep 1
    clear
}

function addBackupOwner() {
    gnokey maketx call -pkgpath "gno.land/r/n2p5/config" \
        -func "AddBackupOwner" -gas-fee 1000000ugnot \
        -gas-wanted 5000000 -send "" \
        -args "g1yfts8fy9jyfeca4p42em6mcttfwcypkpkfx0rv" \
        -broadcast -chainid "portal-loop" \
        -remote https://rpc.gno.land:443 \
        n2p5
        delayAndClear
}

function removeAdmin() {
    gnokey maketx call -pkgpath "gno.land/r/n2p5/config" \
        -func "RemoveAdmin" -gas-fee 1000000ugnot \
        -gas-wanted 5000000 -send "" \
        -args "g1yfts8fy9jyfeca4p42em6mcttfwcypkpkfx0rv" \
        -broadcast -chainid "portal-loop" \
        -remote https://rpc.gno.land:443 \
        n2p5
        delayAndClear
}

function claimOwnership() {
    local account=$1
    gnokey maketx call -pkgpath "gno.land/r/n2p5/config" \
        -func "ClaimOwnership" -gas-fee 1000000ugnot \
        -gas-wanted 5000000 -send "" \
        -broadcast -chainid "portal-loop" \
        -remote https://rpc.gno.land:443 \
        "$account"
        delayAndClear
}

function addChunk() {
    local filename=$1
    FILE_CONTENTS=$(cat "$filename")
    gnokey maketx call -pkgpath "gno.land/r/n2p5/home" \
        -func "Add" -gas-fee 1000000ugnot \
        -gas-wanted 100000000 -send "" \
        -broadcast -chainid "portal-loop" \
        -remote https://rpc.gno.land:443 \
        -args "$FILE_CONTENTS" \
        n2p5
        delayAndClear
}

function promote() {
    gnokey maketx call -pkgpath "gno.land/r/n2p5/home" \
        -func "Promote" -gas-fee 1000000ugnot \
        -gas-wanted 5000000 -send "" \
        -broadcast -chainid "portal-loop" \
        -remote https://rpc.gno.land:443 \
        n2p5
        delayAndClear
}

function flush() {
    gnokey maketx call -pkgpath "gno.land/r/n2p5/home" \
        -func "Promote" -gas-fee 1000000ugnot \
        -gas-wanted 5000000 -send "" \
        -broadcast -chainid "portal-loop" \
        -remote https://rpc.gno.land:443 \
        n2p5
        delayAndClear
}