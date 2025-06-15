maintainer=("quileon <quileon@duck.com>")
pkgname="wine-wow64"
pkgver="10.10"
pkgrel="1"
url="https://www.winehq.org/"
arch=("amd64")
pkgdesc="Wine 64-bit with 32-bit support"
source=(
  "https://dl.winehq.org/wine/source/${pkgver%.*}.x/wine-${pkgver}.tar.xz"
  "30-win32-aliases.conf"
  "wine-binfmt.conf"
)
sha256sums=("SKIP")
depends=(
  "winetricks"
)
makedepends=(
  "bison"
  "dctrl-tools"
  "flex"
  "fontforge-nox"
  "freeglut3-dev"
  "gcc-mingw-w64-i686"
  "gcc-mingw-w64-x86-64"
  "gettext"
  "icoutils"
  "imagemagick"
  "libasound2-dev"
  "libcapi20-dev"
  "libcups2-dev"
  "libdbus-1-dev"
  "libfontconfig-dev"
  "libfreetype-dev"
  "libgettextpo-dev"
  "libgl-dev"
  "libglu1-mesa-dev"
  "libgnutls28-dev"
  "libgphoto2-dev"
  "libgstreamer-plugins-base1.0-dev"
  "libkrb5-dev"
  "libldap2-dev"
  "libncurses-dev"
  "libopenal-dev"
  "libosmesa6-dev"
  "libpcap0.8-dev"
  "libpcsclite-dev"
  "libpulse-dev"
  "librsvg2-bin"
  "libsdl2-dev"
  "libssl-dev"
  "libudev-dev"
  "libunwind-dev"
  "libusb-1.0-0-dev"
  "libv4l-dev"
  "libvulkan-dev"
  "libwayland-dev"
  "libx11-dev"
  "libxcomposite-dev"
  "libxcursor-dev"
  "libxext-dev"
  "libxfixes-dev"
  "libxi-dev"
  "libxinerama-dev"
  "libxkbfile-dev"
  "libxkbregistry-dev"
  "libxml-libxml-perl"
  "libxmu-dev"
  "libxrandr-dev"
  "libxrender-dev"
  "libxt-dev"
  "libxxf86dga-dev"
  "libxxf86vm-dev"
  "libz-mingw-w64-dev"
  "lzma"
  "ocl-icd-opencl-dev"
  "pkg-config"
  "quilt"
  "sharutils"
  "unicode-idna"
  "unixodbc-dev"
  "unzip"
)

build() {
  # Apply flags for cross-compilation
  export CROSSCFLAGS="-O2 -pipe"
  export CROSSCXXFLAGS="-O2 -pipe"
  export CROSSLDFLAGS="-Wl,-O1"

  # Create build directory outside source tree
  mkdir -p build
  cd build

  # Configure from the extracted source
  ../wine-"${pkgver}"/configure \
    --disable-tests \
    --prefix=/opt/wines/"${pkgname}" \
    --libdir=/opt/wines/"${pkgname}"/lib \
    --enable-archs=x86_64,i386

  make -j"${NCPU}"
}

package() {
  cd build

  # Install to custom location in staging directory (${pkgdir})
  make prefix="${pkgdir}/opt/wines/${pkgname}" \
    libdir="${pkgdir}/opt/wines/${pkgname}/lib" \
    dlldir="${pkgdir}/opt/wines/${pkgname}/lib/wine" install

  # Create wine64 symlink in the custom location
  ln -sf "/opt/wines/${pkgname}/bin/wine" "${pkgdir}/opt/wines/${pkgname}/bin/wine64"

  # Font aliasing settings for Win32 applications
  install -Dm644 "${srcdir}/30-win32-aliases.conf" -t "${pkgdir}/usr/share/fontconfig/conf.avail/"
  install -d "${pkgdir}/usr/share/fontconfig/conf.default"
  ln -s "../conf.avail/30-win32-aliases.conf" "${pkgdir}/usr/share/fontconfig/conf.default/30-win32-aliases.conf"

  # Binary format support (pointing to custom location)
  install -d "${pkgdir}/usr/lib/binfmt.d"
  sed "s|/usr/bin/wine|/opt/wines/${pkgname}/bin/wine|" "${srcdir}/wine-binfmt.conf" > "${pkgdir}/usr/lib/binfmt.d/wine-wow64.conf"
}
