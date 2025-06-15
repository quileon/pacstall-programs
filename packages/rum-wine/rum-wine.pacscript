maintainer=("quileon <quileon@duck.com>")
pkgname="rum-wine"
pkgver=394d75c47310244164d387f3319e2d2dbd4d0c30
pkgrel=1
gives=("rum")
url="https://gitlab.com/xkero/rum"
arch=("amd64")
pkgdesc="Switch between multiple versions of wine and prefixes via a simple bash script"
source=("git+https://gitlab.com/xkero/rum.git")
sha256sums=("SKIP")
depends=(
  "winetricks"
)
optdepends=(
  "wine"
  "wine-wow64"
)
provides=("rum")

package() {
  cd rum

  install -Dm755 rum "${pkgdir}/usr/bin/rum"
}
