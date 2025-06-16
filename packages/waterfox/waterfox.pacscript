maintainer=("quileon <quileon@duck.com>")
pkgname="waterfox"
pkgver=6.5.9
pkgrel=1
url="https://www.waterfox.net"
arch=("amd64")
pkgdesc="Fast and Private Web Browser"
source=("https://cdn1.waterfox.net/waterfox/releases/${pkgver}/Linux_x86_64/waterfox-${pkgver}.tar.bz2")
sha512sums=(
  "dbd9ce9bcb17602e41ccdfaa17aafb72c42cc3ed68ea0ff253ec1e839448106ee1708bf7916a7394bed34108dd759cceee9b587cc7340823c026830e4d6e7601"
  "e593d1a8a8dca3cac2f04f85a83ca6b9e68a0f3feee4e3ffc2cb2db18658774fcb77c55455f3db032e8e831e1b6501fedf3518d923e95b66a044c8e8abba9f77"
)
provides=("waterfox")
license=("MPL-2.0")

package() {
  # Create directories
  install -d "${pkgdir}/{usr/{bin,share/applications},opt}"

  # Copy desktop file
  install -m644 "${srcdir}/waterfox.desktop" "${pkgdir}/usr/share/applications/waterfox.desktop"

  # Copy waterfox directory
  cp -r "waterfox" "${pkgdir}/opt/waterfox"

  # Copy icons
  for size in 16 22 24 32 48 64 128; do
    # Create icon directory
    install -d "${pkgdir}/usr/share/icons/hicolor/${size}x${size}/apps"
    # Link the icon
    ln -Ts "/opt/waterfox/browser/chrome/icons/default/default${size}.png" "${pkgdir}/usr/share/icons/hicolor/${size}x${size}/apps/waterfox.png"
  done

  # Copy the main binary
  ln -s "/opt/waterfox/waterfox" "${pkgdir}/usr/bin/waterfox"

  # Add additional settings
  install -Dm644 /dev/stdin "${pkgdir}/opt/waterfox/browser/defaults/preferences/vendor.js" << END
// Disable default browser checking
pref("browser.shell.checkDefaultBrowser", false);

// Use LANG environment variable to choose locale
pref("intl.locale.requested", "");

// Automatic installation of updates won't work on root, so disable this
pref("app.update.auto", false);

// Use system-provided dictionaries
pref("spellchecker.dictionary_path", "/usr/share/hunspell");
END

  # Disable automatic updates
  install -Dm644 /dev/stdin "${pkgdir}/opt/waterfox/distribution/policies.json" << END
{
    "policies": {
        "AppAutoUpdate": false,
        "ManualAppUpdateOnly": true
    }
}
END
}
