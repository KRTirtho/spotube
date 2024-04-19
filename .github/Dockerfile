ARG FLUTTER_VERSION
ARG BUILD_VERSION

FROM fischerscode/flutter-sudo:${FLUTTER_VERSION}

WORKDIR /app

# Install dependencies
RUN sudo apt-get update &&\
  sudo apt-get install -y tar clang cmake ninja-build pkg-config libgtk-3-dev make python3-pip python3-setuptools desktop-file-utils libgdk-pixbuf2.0-dev fakeroot strace fuse libunwind-dev locate patchelf gir1.2-appindicator3-0.1 libappindicator3-1 libappindicator3-dev libsecret-1-0 libjsoncpp25 libsecret-1-dev libjsoncpp-dev libnotify-bin libnotify-dev mpv libmpv-dev rpm &&\
  sudo rm -rf /var/lib/apt/lists/*

COPY . .

RUN sudo chown -R $(whoami) /app

RUN flutter pub get &&\
  flutter config --enable-linux-desktop &&\
  flutter pub get &&\
  dart run build_runner build --delete-conflicting-outputs

RUN dart pub global activate flutter_distributor &&\
  alias dpkg-deb="dpkg-deb --Zxz" &&\
  flutter_distributor package --platform=linux --targets=deb &&\
  flutter_distributor package --platform=linux --targets=rpm


RUN make tar VERSION=${BUILD_VERSION} ARCH=arm64 PKG_ARCH=aarch64

RUN mv build/spotube-linux-*-aarch64.tar.xz dist/ &&\
  mv dist/**/spotube-*-linux.deb dist/Spotube-linux-aarch64.deb &&\
  mv dist/**/spotube-*-linux.rpm dist/Spotube-linux-aarch64.rpm