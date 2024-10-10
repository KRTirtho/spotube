#!/bin/bash
# Written on 10 Oct. 2024 4pm Berlin Time (CEST)

# Script to update Spotube on Linux (direct binaries via tar.xz)
# For letting it run in a crontab or manually

# less sophisticated, old oneliner: arch="aarch64";p="/usr/share/spotube-bin"; a=$(curl -s https://api.github.com/repos/krtirtho/spotube/releases/latest | sed 's/[()",{}]/ /g; s/ /\n/g' | grep "https.*releases/download.*tar.xz" | grep "$arch"); wget "$a" -O "$p/test.tar.xz" && tar -xJf "$p/test.tar.xz"  && rm "$p/test.tar.xz" && echo "$(date -I'seconds')|$a" >> "$p/lastupdate.txt"

p="/usr/share/spotube-bin" # Path where the tar.xz should be downloaded and unpacked
tmpf="$p/test.tar.xz" # temporary .tar.xz name and location (within Path p)
repo="krtirtho/spotube" # define repo path
arch="x86_64" # arch? either aarch64 or x86_64
url="https://api.github.com/repos/$repo/releases/latest"
user="dnr"

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
mkdir "$p" # add directory if not yet existing (including subtree)
chown "$user":"$user" "$p" -R # permissions fix

cd "$p" # avoid the does not get unpacked bug by joining dir

curl -L -s -o "$tmpf" "$a"  # download, save tar.xz (tmpf)
tar -xJf "$tmpf" # unpack tar.xz (tmpf)

chown "$user":"$user" "$p" -R # permissions fix

if [ ! -f "$tmpf" ]; then
  echo "[ERROR]: UPDATE FAILED temporary file: '$tmpf' not found! Looks like it was not downloaded from repo.";
  exit;
fi

# when updated
rm "$tmpf"
echo "$(date -I'seconds')|$a" >> "$p/lastupdate.txt" # add datetime and tar.xz link entry to lastupdate.txt
echo "[+] UPDATE LOOKS SUCCESSFUL. CHECK BY RUNNING $p/spotube";
