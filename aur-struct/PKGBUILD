# Maintainer: Kingkor Roy Tirtho <krtirho@gmail.com>
pkgname=spotube-bin
pkgver=1.1.0
pkgrel=1
epoch=
pkgdesc="A lightweight free Spotify desktop-client which handles playback manually, streams music using Youtube & no Spotify premium account is needed"
arch=(x86_64)
url="https://github.com/KRTirtho/spotube/"
license=('BSD-4-Clause')
groups=()
depends=('libkeybinder3')
makedepends=()
checkdepends=()
optdepends=()
provides=()
conflicts=()
replaces=()
backup=()
options=()
install=
changelog=
source=("https://github.com/KRTirtho/spotube/releases/download/v${pkgver}/Spotube-linux-x86_64.tar.xz")
noextract=()
md5sums=(0db87627ddf753bc7f09ebbb282184ee)
validpgpkeys=()

package(){
  install -dm755 "${pkgdir}/usr/share/icons/${pkgname}"
  install -dm755 "${pkgdir}/usr/share/applications"
  install -dm755 "${pkgdir}/usr/share/${pkgname}"
  install -dm755 "${pkgdir}/usr/bin"
  cp -ra ./ "${pkgdir}/usr/share/${pkgname}"
  cp ./spotube.desktop "${pkgdir}/usr/share/applications"
  cp ./spotube-logo.png "${pkgdir}/usr/share/icons/${pkgname}"
  ln -s "/usr/share/${pkgname}/spotube" "${pkgdir}/usr/bin/${pkgname}"
}
