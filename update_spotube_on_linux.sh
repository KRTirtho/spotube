#!/bin/bash
# Script to update Spotube on Linux (direct binaries via tar.xz)
# For letting it run in a crontab or manually

# arch possibilities: either aarch64 or x86_6
# path and tmpf (temp file for .tar.xz) whatever you choose

# less sophisticated, old oneliner: arch="aarch64";p="/usr/share/spotube-bin"; a=$(curl -s https://api.github.com/repos/krtirtho/spotube/releases/latest | sed 's/[()",{}]/ /g; s/ /\n/g' | grep "https.*releases/download.*tar.xz" | grep "$arch"); wget "$a" -O "$p/test.tar.xz" && tar -xJf "$p/test.tar.xz"  && rm "$p/test.tar.xz" && echo "$(date -I'seconds')|$a" >> "$p/lastupdate.txt"


p="/usr/share/spotube-bin" # Path where the tar.xz should be downloaded and unpacked
tmpf="$p/test.tar.xz"
repo="krtirtho/spotube" # define repo path
url="https://api.github.com/repos/$repo/releases/latest"
arch="x86_64" # arch?

# check if running as root
if [ $(id -u) -ne 0 ]; then
  echo "[ERROR]: This updater must be run as root";
  exit
fi

if [ "$arch" != "aarch64" ] && [ "$arch" != "x86_64" ]; then
  echo "[ERROR]: UPDATE FAILED. Arch must be either x86_64 or aarch64. Currently it is: '$arch' "
  exit
fi

a=$(curl -s "$url" | sed 's/[()",{}]/ /g; s/ /\n/g' | grep "https.*releases/download.*tar.xz" | grep "$arch") # select the correct binary from Github release path via JSON API
if [ -z "$a" ]; then
  echo "[ERROR]: UPDATE FAILED: Url '$url' is invalid, exiting.";
  exit;
fi

# rm "$p/*" -r # optionally remove everything in the folder before (avoiding left overs and other issues)

# creating $p dir, downloading & saving, unpacking tmpf/tar.xz
mkdir -p "$p" # add directory if not yet existing (including subtree)
curl -L -s -o "$p/test.tar.xz" "$a"  # download, save tar.xz (tmpf)
tar -xJf "$tmpf" # unpack tar.xz (tmpf)

if [ ! -f "$tmpf" ]; then
  echo "[ERROR]: UPDATE FAILED temporary file: '$tmpf' not found! Looks like it was not downloaded from repo.";
  exit;
fi

# when updated
rm "$tmpf"
echo "$(date -I'seconds')|$a" >> "$p/lastupdate.txt" # add datetime and tar.xz link entry to lastupdate.txt
echo "[+] UPDATE LOOKS SUCCESSFUL. CHECK BY RUNNING $p/spotube";
