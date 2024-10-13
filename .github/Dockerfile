ARG FLUTTER_VERSION

FROM --platform=linux/arm64 krtirtho/flutter_distributor:${FLUTTER_VERSION}

ARG BUILD_VERSION

WORKDIR /app

COPY . .

RUN chown -R $(whoami) /app

RUN rustup target add aarch64-unknown-linux-gnu

RUN flutter pub get

RUN alias dpkg-deb="dpkg-deb --Zxz" &&\
  flutter_distributor package --platform=linux --targets=deb --skip-clean

RUN make tar VERSION=${BUILD_VERSION} ARCH=arm64 PKG_ARCH=aarch64

RUN mv build/spotube-linux-*-aarch64.tar.xz dist/ &&\
  mv dist/**/spotube-*-linux.deb dist/Spotube-linux-aarch64.deb

CMD [ "sleep", "5000000" ]