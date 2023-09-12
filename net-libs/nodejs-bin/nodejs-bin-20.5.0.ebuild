EAPI=7

DESCRIPTION="A JavaScript runtime built on Chrome's V8 JavaScript engine"
HOMEPAGE="https://nodejs.org/"
LICENSE="Apache-1.1 Apache-2.0 BSD BSD-2 MIT"

SRC_URI="
elibc_glibc? ( https://nodejs.org/dist/v20.5.0/node-v20.5.0-linux-x64.tar.xz -> ${P}.tar.xz )
elibc_musl? ( https://unofficial-builds.nodejs.org/download/release/v20.5.0/node-v20.5.0-linux-x64-musl.tar.xz -> ${P}.tar.xz )
"
KEYWORDS="amd64"
SLOT="${PV}"

S="${WORKDIR}/node-v${PV}-linux-x64"

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

src_install() {
  local node_dir="/usr/share/node-${PV}"
	insinto "${node_dir}/" &&
		doins -r "${S}"/* ||
		die "Error installing nodeJS files into ${node_dir}"

  fperms -R 755 "${node_dir}"/lib/node_modules/corepack/dist
	fperms -R 755 "${node_dir}"/lib/node_modules/npm/bin
	fperms -R 755 "${node_dir}"/bin/node

	dosym "${node_dir}/lib/node_modules/corepack/dist/corepack.js" "${node_dir}/bin/corepack"
	dosym "${node_dir}/lib/node_modules/npm/bin/npm-cli.js" "${node_dir}/bin/npm"
	dosym "${node_dir}/lib/node_modules/npm/bin/npx-cli.js" "${node_dir}/bin/npx"

	default

	# if use doc; then
		# dodoc -r "${S}"/share/doc/*
		# doman "${S}"/share/man/man1/node.1
		# NPM
		# doman "${S}"/lib/node_modules/npm/man{1,5,7}/*
	# fi
}
