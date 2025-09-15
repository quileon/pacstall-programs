maintainer=("quileon <quileon@duck.com")
pkgname="neovide-bin"
_pkgname="neovide"
pkgver=0.15.1
pkgrel=1
pkgdesc="No Nonsense Neovim Client in Rust"
url="https://neovide.dev"
arch=("amd64")
depends=()
builddepends=()
provides=("neovide")
conflicts=("neovide" "neovide-git")
source=(
  "https://github.com/neovide/neovide/releases/download/${pkgver}/neovide.AppImage"
)
sha256sums=("91316855da654d22ba9ae01dc9811cc1581e4e3d3118f3fbe4bfe1272300475b")

prepare() {
  cd "${srcdir}"

  chmod +x neovide.AppImage
  ./neovide.AppImage --appimage-extract
}

build() {
  cd "${srcdir}"

  chmod -R a-x+rX squashfs-root/usr
}

package() {
  cd "${srcdir}"

  # Install icons
  for size in scalable 16x16 32x32 64x64 128x128 256x256 512x512 1024x1024; do
    install -Dm644 "squashfs-root/usr/share/icons/hicolor/${size}/apps/neovide.svg" -t "${pkgdir}/usr/share/icons/hicolor/${size}/apps"
  done

  # Install files
  install -dm755 "${pkgdir}/usr/lib/${_pkgname}"

  cp -R "${srcdir}"/squashfs-root/* "${pkgdir}/usr/lib/${_pkgname}"

  # Install desktop file
  install -Dm644 "squashfs-root/neovide.desktop" -t "${pkgdir}/usr/share/applications"

  # Install main binary
  install -Dm755 "squashfs-root/usr/bin/neovide" -t "${pkgdir}/usr/bin"
}
