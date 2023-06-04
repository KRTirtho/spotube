#!/usr/bin/env bash

# Varibles
fname="$(basename $0)"
installDir='/usr/share/spotube'
desktopFile='/usr/share/applications/spotube.desktop'
appdata='/usr/share/appdata/spotube.appdata.xml'
icon='/usr/share/icons/spotube/spotube-logo.png'
symlink='/usr/bin/spotube'
temp='/tmp/spotube-installer'
latestVer="$(curl --silent "https://api.github.com/repos/KRTirtho/spotube/releases/latest" \ | grep -Po '"tag_name": "\K.*?(?=")')"

# Root check - From CAAIS (https://codeberg.org/RaptaG/CAAIS), under GPL-3.0
function rootCheck() {
     if [ "${EUID}" -ne 0 ]; then
          echo "Error: Root permissions are required for ${fname} to work."
          echo "Please run './${fname}' for more information."
          exit 1
     fi
}

# Flags
function help(){
  echo "Usage: sudo ./${fname} [flags]"
  echo 'Flags:'
  echo '  -i, --install <version>    Specify what version to download, defaults to the latest.'
  echo '  -h, --help                 This help menu'
  echo '  -r, --remove               Removes Spotube from your system'
  exit 0
}

# Checks whether a given command exists or not and returns bool
function command_exists() {
    command -v "$@" >/dev/null 2>&1
}

function install_deps(){
    local debianDeps='curl tar mpv libappindicator3-1 gir1.2-appindicator3-0.1 libsecret-1-0 libnotify-bin libjsoncpp25'
    local rpmDeps='curl tar mpv libappindicator jsoncpp libsecret libnotify'
    local archDeps='curl tar mpv libappindicator-gtk3 libsecret jsoncpp libnotify'

    if command_exists apt; then
        sudo apt install -y ${debianDeps}
    elif command_exists dnf; then
        sudo dnf install -y ${debianDeps}
    elif command_exists yum; then
        sudo yum install -y ${rpmDeps}
    elif command_exists zypper; then
        sudo zypper install -y ${rpmDeps}
    elif command_exists pacman; then
        sudo pacman -Sy ${archDeps}
    else
    # TODO - install them
        echo "Your package manager is not supported by this script. Please install the dependencies manually."
        echo "The dependencies are: curl, tar, mpv, appindicator, libsecret, jsoncpp, libnotify"
    fi
}

function download_extract_spotube(){
  local tarPath="/tmp/spotube-${ver}.tar.xz"
  local donwloadURL="https://github.com/KRTirtho/spotube/releases/download/v${ver}/spotube-linux-${ver}-x86_64.tar.xz"

  if [ "${ver}" = "nightly" ]; then
      downloadURL"=https://github.com/KRTirtho/spotube/releases/download/nightly/spotube-linux-nightly-x86_64.tar.xz"
  fi

  rm -rf ${temp}
  mkdir -p ${temp}

  # check if already exists downloaded file
  if [ -f ${tarPath} ]; then
    echo "Installation file detected. Skipping download..."
  else
    echo "Downloading spotube-${ver}.tar.xz..."
    curl -L ${downloadURL} -o ${tarPath}
  fi

  tar -xf ${tarPath} -C ${temp}

  # Is $temp empty or not
  if [ ! "$(ls -A $TEMP_DIR)" ]; then
    echo 'Failed to extract the tarball. Redownloading...'
    rm -f ${tarPath}
    curl -L ${downloadURL} -o ${tarPath}
    tar -xf ${tarPath} -C ${temp}
  fi
  
  # Once again
  if [ ! "$(ls -A $TEMP_DIR)" ]; then
    echo 'Failed to extract the tarball. Installation aborted.'
    exit 1
  fi
}

function install_spotube(){
    if [ -d ${installDir} ]; then
        echo -n "Spotube is already installed. Do you want to reinstall it? [y/N]"
        read reinstall

        case "${reinstall}" in
        [yY]*)
            uninstall_spotube
            ;;
        *)
            echo 'Aborting installation...'
            exit 1
            ;;
        esac
    fi

    mkdir -p ${installDir}
    mv ${temp}/data ${installDir}
    mv ${temp}/lib ${installDir}
    mv ${temp}/spotube ${installDir}
    mv ${temp}/spotube.desktop ${desktopDir}
    mv ${temp}/com.github.KRTirtho.Spotube.appdata.xml ${appdata}
    mkdir -p /usr/share/icons/spotube
    mv ${temp}/spotube-logo.png ${icon}
    ln -s /usr/share/spotube/spotube ${symlink}

    # Clean up
    rm -rf ${temp}
    echo "Spotube ${ver} has been installed successfully!"
}

function uninstall_spotube(){
    echo -n "Are you sure you want to uninstall Spotube? [y/N]"
    read confirm

    case "${confirm}" in
    [yY]*)
            echo 'Unstalling Spotube..'
            rm -rf ${installDir} ${desktopDir} ${appdata} ${icon} ${symlink}
            ;;
    *)
            echo 'Aborting...'
            exit 0
            ;;
    esac
}

case "$1" in
-i | --install)
    if [ "$2" != "" ]; then
        ver="$2"
    else
        ver="${latestVer}"
    fi
    
    rootCheck
    install_deps
    download_extract_spotube
    install_spotube
    ;;
-r | --remove)
    rootCheck
    uninstall_spotube
    exit 0
    ;;
-h | --help | "")
    help
    exit 0
    ;;
*)
    echo "Invalid flag "$1"."
    echo "Please run ./${fname} for more information."
    exit 1
    ;;
esac
