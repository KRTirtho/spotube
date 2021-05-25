FROM ubuntu:latest

WORKDIR /app
SHELL ["/bin/bash", "-c"]

RUN apt-get update &&\
  DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends install\
  ca-certificates\
  pkg-config\
  build-essential\
  cmake\
  gcc-7\
  curl\
  mesa-common-dev\
  libglu1-mesa-dev\
  libqt5x11extras5\
  xcb\
  mpv\
  python\
  fuse\
  kmod

RUN addgroup fuse

RUN apt-get install -y --reinstall libxcb-xinerama0
# removing broken youtube-dl & giving execution permissions
RUN apt-get remove -y youtube-dl
RUN curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl && chmod a+rx /usr/local/bin/youtube-dl

RUN mkdir -p /usr/local/nvm
ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 14.17.0

# Install nvm with node and npm
RUN curl https://raw.githubusercontent.com/creationix/nvm/v0.38.0/install.sh | bash \
  && source $NVM_DIR/nvm.sh \
  && nvm install $NODE_VERSION \
  && nvm alias default $NODE_VERSION \
  && nvm use default

ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH      $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

COPY ./package.json ./
RUN npm install
COPY ./ ./

CMD ["sleep", "500000" ]

