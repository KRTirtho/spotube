#!/bin/bash


INSTLLATION_DIR=/usr/share/spotube
DESKTOP_FILE_PATH=/usr/share/applications/spotube.desktop
APP_DATA_PATH=/usr/share/appdata/spotube.appdata.xml
ICON_PATH=/usr/share/icons/spotube/spotube-logo.png
BIN_SYMLINK_PATH=/usr/bin/spotube

TEMP_DIR=/tmp/spotube-installer
VERSION="2.7.1"

function spotube_help(){
  # available flags are -v or --version to specify what version to download
  echo "Usage: ./install.sh [flags]"
  echo "Flags:"
  echo "  -v, --version <version>    Specify what version to download. Default: $VERSION"
  echo "  -h, --help                 Show this help message"
  echo "  -r, --remove               Remove spotube from your system"
  exit 0
}

# a function to check if a given command exists or not and returns bool
function command_exists() {
    command -v "$@" >/dev/null 2>&1
}

function install_deps(){
    local DEBIAN_DEPS="curl tar mpv libappindicator3-1 gir1.2-appindicator3-0.1 libsecret-1-0 libnotify-bin libjsoncpp25"
    local RPM_DEPS="curl tar mpv libappindicator jsoncpp libsecret libnotify"
    local ARCH_DEPS="curl tar mpv libappindicator-gtk3 libsecret jsoncpp libnotify"

    if command_exists apt; then
        sudo apt install -y $DEBIAN_DEPS
    elif command_exists dnf; then
        sudo dnf install -y $RPM_DEPS
    elif command_exists yum; then
        sudo yum install -y $RPM_DEPS
    elif command_exists zypper; then
        sudo zypper install -y $RPM_DEPS
    elif command_exists pacman; then
        sudo pacman -Sy $ARCH_DEPS
    else
        echo "Your package manager is not supported by this script. Please install the dependencies manually."
        echo "The dependencies are: curl, tar, mpv, appindicator, libsecret, jsoncpp, libnotify"
fi
}

function download_extract_spotube(){
  local TAR_PATH=/tmp/spotube-$VERSION.tar.xz
  local DOWNLOAD_URL=https://github.com/KRTirtho/spotube/releases/download/v$VERSION/spotube-linux-$VERSION-x86_64.tar.xz

  # check if version is nightly

  if [ "$VERSION" = "nightly" ]; then
      DOWNLOAD_URL=https://github.com/KRTirtho/spotube/releases/download/nightly/spotube-linux-nightly-x86_64.tar.xz
  fi

  
  rm -rf $TEMP_DIR
  mkdir -p $TEMP_DIR
  

  # check if already exists downloaded file
  if [ -f $TAR_PATH ]; then
    echo "Found spotube-$VERSION.tar.xz in /tmp. Skipping download..."
  else
    echo "Downloading spotube-$VERSION.tar.xz..."
    curl -L $DOWNLOAD_URL -o $TAR_PATH
  fi

  # Extract the tarball
  tar -xf $TAR_PATH -C $TEMP_DIR

  # check if $TEMP_DIR empty or not

  if [ ! "$(ls -A $TEMP_DIR)" ]; then
    echo "Failed to extract the tarball. Redownloading..."
    rm -f $TAR_PATH
    curl -L $DOWNLOAD_URL -o $TAR_PATH
    tar -xf $TAR_PATH -C $TEMP_DIR
  fi
  
  # checking one last time
  if [ ! "$(ls -A $TEMP_DIR)" ]; then
    echo "Failed to extract the tarball. Aborting installation..."
    exit 1
  fi
}

function install_spotube(){
    # check if exists and uninstall if user allows

    if [ -d $INSTLLATION_DIR ]; then
        echo "Spotube is already installed. Do you want to uninstall it and then install? [y/N]"
        read -r uninstall
        if [ "$uninstall" = "y" ] || [ "$uninstall" = "Y" ]; then
            uninstall_spotube
        else
            echo "Aborting installation..."
            exit 1
        fi
    fi
  
    # Move the files to /usr/share/spotube

    sudo mkdir -p $INSTLLATION_DIR

    sudo mv $TEMP_DIR/data $INSTLLATION_DIR
    sudo mv $TEMP_DIR/lib $INSTLLATION_DIR
    sudo mv $TEMP_DIR/spotube $INSTLLATION_DIR

    # Move the desktop file to /usr/share/applications

    sudo mv $TEMP_DIR/spotube.desktop $DESKTOP_FILE_PATH

    # Move the appdata file to /usr/share/appdata

    sudo mv $TEMP_DIR/com.github.KRTirtho.Spotube.appdata.xml $APP_DATA_PATH

    # Move the logo to /usr/share/icons/spotube

    sudo mkdir -p /usr/share/icons/spotube

    sudo mv $TEMP_DIR/spotube-logo.png $ICON_PATH

    # Create a symlink to /usr/bin

    sudo ln -s /usr/share/spotube/spotube $BIN_SYMLINK_PATH

    # Clean up

    rm -rf $TEMP_DIR

    echo "Spotube $VERSION has been installed successfully!"
}

function uninstall_spotube(){
    # confirm

    echo "Are you sure you want to uninstall Spotube?"
    echo
    echo "This will remove following files and directories:"
    echo "  $INSTLLATION_DIR"
    echo "  $DESKTOP_FILE_PATH"
    echo "  $APP_DATA_PATH"
    echo "  $ICON_PATH"
    echo "  $BIN_SYMLINK_PATH"
    echo
    echo "[y/N]"

    read -r CONFIRMATION

    if [[ "$CONFIRMATION" != "y" ]]; then
        echo "Aborting uninstallation..."
        exit 0
    fi

    # remove the files


    sudo rm -rf $INSTLLATION_DIR $DESKTOP_FILE_PATH $APP_DATA_PATH $ICON_PATH $BIN_SYMLINK_PATH
}

# parse arguments -v, --version, -r, --remove, -h, --help

while [[ "$#" -gt 0 ]]; do
    case $1 in
        -v|--version) VERSION="$2"; shift ;;
        -r|--remove) uninstall_spotube; exit 0 ;;
        -h|--help) spotube_help; exit 0 ;;
        *) echo "Unknown parameter passed: $1"; spotube_help; exit 1 ;;
    esac
    shift
done

install_deps
download_extract_spotube
install_spotube