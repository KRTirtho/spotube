ARG FLUTTER_VERSION

FROM --platform=linux/arm64 krtirtho/flutter_distributor_arm64:${FLUTTER_VERSION}

ARG BUILD_VERSION

WORKDIR /app

COPY . .

RUN chown -R $(whoami) /app

RUN flutter pub get &&\
  flutter config --enable-linux-desktop &&\
  flutter pub get &&\
  dart run build_runner build --delete-conflicting-outputs

RUN alias dpkg-deb="dpkg-deb --Zxz" &&\
  flutter_distributor package --platform=linux --targets=deb &&\
  flutter_distributor package --platform=linux --targets=rpm


RUN make tar VERSION=${BUILD_VERSION} ARCH=arm64 PKG_ARCH=aarch64

RUN mv build/spotube-linux-*-aarch64.tar.xz dist/ &&\
  mv dist/**/spotube-*-linux.deb dist/Spotube-linux-aarch64.deb &&\
  mv dist/**/spotube-*-linux.rpm dist/Spotube-linux-aarch64.rpm