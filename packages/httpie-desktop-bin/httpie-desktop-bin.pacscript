maintainer=("quileon <quileon@duck.com>")
pkgname="httpie-desktop-bin"
_pkgname=httpie-desktop
pkgver=2025.2.0
pkgrel=1
pkgdesc="HTTPie for Desktop"
arch=("amd64")
url="https://httpie.io/product"
depends=('libgtk-3-0t64' 'libasound2' 'libnss3')
builddepends=('fuse2')
provides=('httpie-desktop')
conflicts=('httpie-desktop-appimage')

source=("https://github.com/httpie/desktop/releases/download/v${pkgver}/HTTPie-${pkgver}.AppImage")
sha256sums=('a850e215741b60087079086061f656fe550cb66c34f6da93f6dfc63c946d654f')

[[ ${CARCH} == "amd64" ]] && _filename=HTTPie-${pkgver}.AppImage
[[ ${CARCH} == "aarch64" ]] && _filename=HTTPie-${pkgver}-arm64.AppImage

prepare() {
  cd "${srcdir}"

  chmod +x "${_filename}"
  ./"${_filename}" --appimage-extract
}

build() {
  cd "${srcdir}"

  sed -i -E "s|Exec=AppRun|Exec=/usr/bin/httpie-desktop|" squashfs-root/httpie.desktop
  chmod -R a-x+rX squashfs-root/usr squashfs-root/locales squashfs-root/resources
}

package() {
  cd "${srcdir}"

  # Install icons
  for size in 16x16 32x32 64x64 128x128 256x256 512x512 1024x1024; do
    install -Dm644 "squashfs-root/usr/share/icons/hicolor/${size}/apps/httpie.png" -t "${pkgdir}/usr/share/icons/hicolor/${size}/apps"
  done

  # Install desktop file
  install -Dm644 "squashfs-root/httpie.desktop" -t "${pkgdir}/usr/share/applications"

  # Install licenses
  install -Dm644 "squashfs-root/LICENSE.electron.txt" -t "${pkgdir}/usr/share/licenses/${_pkgname}"
  install -Dm644 "squashfs-root/LICENSES.chromium.html" -t "${pkgdir}/usr/share/licenses/${_pkgname}"

  # Install files
  install -dm755 "${pkgdir}/usr/lib/${_pkgname}"

  cp -R "${srcdir}"/squashfs-root/* "${pkgdir}/usr/lib/${_pkgname}"

  rm -Rf "${pkgdir}/usr/lib/${_pkgname}/usr"
  rm -Rf "${pkgdir}/usr/lib/${_pkgname}/httpie.png"

  # Install the launcher to /usr/bin
  install -Dm755 "${startdir}/${_pkgname}" "${pkgdir}/usr/bin/${_pkgname}"
}
