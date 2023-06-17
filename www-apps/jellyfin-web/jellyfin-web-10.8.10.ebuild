EAPI=8

DESCRIPTION="Jellyfin puts you in control of managing and streaming your media"
HOMEPAGE="https://jellyfin.readthedocs.io/en/latest/"

SRC_URI="https://github.com/jellyfin/jellyfin-web/archive/refs/tags/v10.8.10.tar.gz -> jellyfin-web-10.8.10.tar.gz"

SLOT="0"
KEYWORDS="amd64 arm64"
DEPEND="acct-user/jellyfin
	net-libs/nodejs[npm]"
RDEPEND="www-apps/jellyfin-server
	net-libs/nodejs[npm]
	acct-user/jellyfin"
INST_DIR="/opt/jellyfin/jellyfin-web/"

src_unpack() {
	unpack ${A}
}

src_compile() {
	npm ci --no-audit
}

src_install() {
        dodir ${INST_DIR}
		insinto ${INST_DIR}
		doins -r dist/*
}
