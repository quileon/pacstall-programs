maintainer=("quileon <quileon@duck.com>")
pkgname="basilisk"
pkgver="2025.04.22"
pkgrel="1"
url="https://www.basilisk-browser.org/"
arch=("amd64")
pkgdesc="A XUL-based open-source web browser."
source=("https://dl.basilisk-browser.org/basilisk-20250422154702.linux-x86_64-gtk3.tar.xz")
sha256sums=("e56a947df18c9ac5c5db726d15b87d16ca4389e876c87726909e06ac4f3255e6")
depends=("libgtk-3-0" "libdbus-glib-1-2" "libxt6")
provides=("web-browser")
conflicts=("basilisk-bin")
license=("MPL-2.0")

package() {
  # The extracted folder name is 'basilisk'
  cd "${srcdir}/basilisk"

  # Install the main application files
  install -d "${pkgdir}/opt/${pkgname}"
  cp -r ./* "${pkgdir}/opt/${pkgname}/"

  # Create the binary link
  install -d "${pkgdir}/usr/bin"
  ln -s "/opt/${pkgname}/basilisk" "${pkgdir}/usr/bin/${pkgname}"

  # Create the .desktop file for application menus
  install -d "${pkgdir}/usr/share/applications"
  cat > "${pkgdir}/usr/share/applications/${pkgname}.desktop" << EOF
[Desktop Entry]
Name=Basilisk
Comment=${pkgdesc}
Exec=/opt/${pkgname}/basilisk %U
Icon=${pkgname}
Terminal=false
Type=Application
Categories=Network;WebBrowser;
StartupWMClass=Basilisk
EOF

  # Install the application icon
  install -Dm644 browser/icons/mozicon128.png "${pkgdir}/usr/share/icons/hicolor/128x128/apps/${pkgname}.png"
}
