#!/usr/bin/env bash

# Varibles
fname="$(basename $0)"
installDir='/usr/share/spotube'
desktopFile='/usr/share/applications/spotube.desktop'
appdata='/usr/share/appdata/spotube.appdata.xml'
icon='/usr/share/icons/spotube/spotube-logo.png'
symlink='/usr/bin/spotube'
temp='/tmp/spotube-installer'
latestVer="$(wget -qO- "https://api.github.com/repos/KRTirtho/spotube/releases/latest" \ | grep -Po '"tag_name": "\K.*?(?=")')"

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
  echo '  -i, --install <version>    Install any Spotube version (if not specified, the latest is installed).'
  echo '  -h, --help                 This help menu'
  echo '  -r, --remove               Removes Spotube from your system'
  exit 0
}

# Checks whether a given command exists or not and returns bool
function command_exists() {
    command -v "$@" >/dev/null 2>&1
}

function install_deps(){
    local debianDeps='mpv libappindicator3-1 gir1.2-appindicator3-0.1 libsecret-1-0 libnotify-bin libjsoncpp25'
    local rpmDeps='mpv libappindicator jsoncpp libsecret libnotify'
    local archDeps='mpv libappindicator-gtk3 libsecret jsoncpp libnotify'

    if command_exists apt; then
        apt install -y ${debianDeps}
    elif command_exists dnf; then
        dnf install -y ${debianDeps}
    elif command_exists yum; then
        yum install -y ${rpmDeps}
    elif command_exists zypper; then
        zypper install -y ${rpmDeps}
    elif command_exists pacman; then
        pacman -Sy ${archDeps}
    else   
    # Maybe one day
    #  # Deps
    #    # JsonCpp
    #    wget https://github.com/open-source-parsers/jsoncpp/tarball/master -O jsoncpp.tar.gz
    #    tar -xf jsoncpp.tar.gz && cd open-source-parsers-jsoncpp-*
        echo 'You have to install some dependancies manually in order for Spotube to work.'
        echo "The deps are the following: ${rpmDeps}"
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

  # Check if already exists downloaded file
  if [ -f ${tarPath} ]; then
    echo "Installation file detected. Skipping download..."
  else
    echo "Downloading spotube-${ver}.tar.xz..."
    wget -q ${downloadURL} -P ${tarPath}
  fi

  tar -xf ${tarPath} -C ${temp}

  # Is $temp empty or not
  if [ ! "$(ls -A ${temp})" ]; then
    echo 'Failed to extract the tarball. Redownloading...'
    rm -f ${tarPath}
    wget -q ${downloadURL} -P ${tarPath}
    tar -xf ${tarPath} -C ${temp}
  fi
  
  # Once again
  if [ ! "$(ls -A ${temp})" ]; then
    echo 'Failed to extract the tarball. Installation aborted.'
    exit 1
  fi
}

function install_spotube(){
    if [ -d ${installDir} ]; then
        echo -n "Spotube is already installed. Do you want to reinstall it? [y/N] "
        read reinstall

        case "${reinstall}" in
        [yY]*)
            uninstall_spotube ;;
        *)
            echo 'Aborting installation...'
            exit 1 ;;
        esac
    fi

    # Install Spotube from temp dir
    mkdir -p ${installDir}
    mv ${temp}/data ${installDir}
    mv ${temp}/lib ${installDir}
    mv ${temp}/spotube ${installDir}
    mv ${temp}/spotube.desktop ${desktopDir}
    mv ${temp}/com.github.KRTirtho.Spotube.appdata.xml ${appdata}
    mkdir -p /usr/share/icons/spotube
    mv ${temp}/spotube-logo.png ${icon}
    ln -s /usr/share/spotube/spotube ${symlink}

    rm -rf ${temp}  # Remove temp dir
    echo "Spotube ${ver} has been installed successfully!"
}

function uninstall_spotube(){
    echo -n "Are you sure you want to uninstall Spotube? [y/N] "
    read confirm

    case "${confirm}" in
    [yY]*)
            echo 'Unstalling Spotube..'
            rm -rf ${installDir} ${desktopDir} ${appdata} ${icon} ${symlink} ;;
    *)
            echo 'Aborting...'
            exit 0 ;;
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
    exit 0 ;;
-r | --remove)
    rootCheck
    uninstall_spotube
    exit 0 ;;
-h | --help | "")
    help
    exit 0 ;;
*)
    echo "Invalid flag '$1'"
    echo "Please run ./${fname} for more information."
    exit 1 ;;
esac
