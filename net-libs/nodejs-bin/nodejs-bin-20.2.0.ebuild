EAPI=7

DESCRIPTION="A JavaScript runtime built on Chrome's V8 JavaScript engine"
HOMEPAGE="https://nodejs.org/"
LICENSE="Apache-1.1 Apache-2.0 BSD BSD-2 MIT"

SRC_URI="https://unofficial-builds.nodejs.org/download/release/v20.2.0/node-v20.2.0-linux-x64-musl.tar.xz -> ${P}.tar.xz"
KEYWORDS="amd64"
SLOT="0"

S="${WORKDIR}/node-v${PV}-linux-x64-musl"

IUSE="doc"

RDEPEND="app-arch/brotli
	dev-libs/libuv
	net-dns/c-ares	
  net-libs/nghttp2
	sys-libs/zlib
	dev-libs/icu
	dev-libs/openssl
	sys-devel/gcc:*"

DEPEND="${RDEPEND}"

src_install(){
	# Install Node
	dobin "${S}"/bin/node
	# Libraries
	insinto "/usr/lib" &&
		doins -r "${S}"/lib/* ||
		die "Error installing libraries into /usr/lib."

	# FIX: Those symlinks are broken due to wrong permissions, set by our friend, portage. Thank you portage.
	# I'll figure it out soon.
  fperms -R 755 /usr/lib/node_modules/corepack/dist
	fperms -R 755 /usr/lib/node_modules/npm/bin

	dosym "/usr/lib/node_modules/corepack/dist/corepack.js" "/usr/bin/corepack"
	dosym "/usr/lib/node_modules/npm/bin/npm-cli.js" "/usr/bin/npm"
	dosym "/usr/lib/node_modules/npm/bin/npx-cli.js" "/usr/bin/npx"

	doheader -r "${S}"/include/*
	default

	if use doc; then
		dodoc -r "${S}"/share/doc/*
		doman "${S}"/share/man/man1/node.1
		# NPM
		doman "${S}"/lib/node_modules/npm/man{1,5,7}/*
	fi
}
