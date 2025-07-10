maintainer=("quileon <quileon@duck.com>")
pkgname="tetris-tui-git"
pkgver="0.1.0"
pkgrel="1"
pkgdesc="Modern Tetris TUI written in Rust"
arch=("amd64")
url="https://github.com/abusch8/Tetris"
license=("GPL-3")
depends=()
makedepends=()
source=("git+https://github.com/abusch8/Tetris")
sha256sums=('SKIP')

build() {
    cd "$srcdir/Tetris"
    make build
}

package() {
    cd "$srcdir/Tetris"
    
    # Install the binary
    install -Dm755 "target/release/tetris" "${pkgdir}/usr/bin/tetris"
    
    # Install the default config file
    install -Dm644 "default_config.ini" "${pkgdir}/usr/share/tetris/default_config.ini"
}