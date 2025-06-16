maintainer=("quileon <quileon@duck.com>")
pkgname="basilisk"
pkgver="2025.06.13"
pkgrel="4"
url="https://www.basilisk-browser.org/"
arch=("amd64")
pkgdesc="A XUL-based open-source web browser."
_source=basilisk-20250612221311.linux-x86_64-gtk3.tar.xz
source=(
  "https://dl.basilisk-browser.org/${_source}"
  "basilisk.desktop"
)
sha256sums=(
  "fa3027133bee06a2777343ac356642d9c27ad52677d928fdab25527a9623d475"
  "3154e32eae7984331b676e57a3d3b72e21d4ff536c16a986393702f3a6b49154"
)
depends=("libgtk-3-0" "libdbus-glib-1-2" "libxt6")
provides=("basilisk")
license=("MPL-2.0")

package() {

  # Create directories
  install -d "${pkgdir}/opt/"
  install -d "${pkgdir}/usr/bin"
  install -d "${pkgdir}/usr/share/applications"

  # Copy basilisk directory
  cp -r "basilisk" "${pkgdir}/opt/${pkgname}/"

  # Copy main binary
  ln -s "/opt/${pkgname}/basilisk" "${pkgdir}/usr/bin/basilisk"

  # Copy icons
  for size in 16 22 24 32 48 64 128; do
    # Check if the icon file exists
    if [[ ! -f "${pkgdir}/opt/${pkgname}/browser/chrome/icons/default/default${size}.png" ]]; then
      echo "Warning: Icon for size ${size} not found, skipping."
      continue
    fi
    # Create icon directory
    install -d "${pkgdir}/usr/share/icons/hicolor/${size}x${size}/apps"
    # Link the icon
    ln -Ts "/opt/${pkgname}/browser/chrome/icons/default/default${size}.png" "${pkgdir}/usr/share/icons/hicolor/${size}x${size}/apps/waterfox.png"
  done
}
