EAPI=8

DESCRIPTION="TypeScript & JavaScript Language Server"
HOMEPAGE="https://www.npmjs.com/package/typescript-language-server"
LICENSE="MIT"

SRC_URI="
https://github.com/typescript-language-server/typescript-language-server/archive/refs/tags/v${PV}.tar.gz"
KEYWORDS="amd64"
SLOT="0"

RDEPEND="net-libs/nodejs || net-libs/nodejs-bin"

DEPEND="${RDEPEND}"

src_install() {
	local node_pkgs_dir="/usr/lib/node-pkgs"
	local pkg_dir="${node_pkgs_dir}/${P}"
	insinto "${pkg_dir}/" &&
		doins ||
		die "Error installing nodeJS files into ${pkg_dir}"

	echo "#!/usr/bin/env bash" > "${D}/usr/bin/typescript-language-server"
	echo "/usr/share/node-20.5.0/bin/node ${pkgdir}/bin/" > "${D}/usr/bin/typescript-language-server"

	default
}
