EAPI=8

DESCRIPTION="Jellyfin puts you in control of managing and streaming your media"
HOMEPAGE="https://jellyfin.readthedocs.io/en/latest/"

SRC_URI="https://github.com/jellyfin/jellyfin/archive/refs/tags/v${PV}.tar.gz -> jellyfin-server-10.8.10.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~arm64"
DEPEND="acct-user/jellyfin
	<dev-dotnet/dotnet-sdk-bin-7.0"
RDEPEND="acct-user/jellyfin
	<dev-dotnet/dotnet-sdk-bin-7.0
  dev-libs/icu
  media-video/ffmpeg[vpx,x264]
  dev-db/sqlite"
INST_DIR="/opt/jellyfin/"

src_unpack() {
	unpack ${A}
	mv jellyfin-10.8.10 jellyfin-server-10.8.10
}

src_compile() {
  export DOTNET_CLI_TELEMETRY_OUTPUT=1

  # FORCE dotnet version 6.x if multiple versions are found
  dotnet new globaljson --sdk-version 6.0.0 --roll-forward latestMinor --force

  dotnet build --configuration Release Jellyfin.Server
}

src_install() {
  # self contained would include dotnet runtime in the build, and is set to true by default
  dotnet publish \
    --configuration Release \
    --output "publish-output/" \
    --self-contained true \
    --use-current-runtime true \
    Jellyfin.Server

  keepdir /var/log/jellyfin
  fowners jellyfin:jellyfin /var/log/jellyfin
  keepdir /etc/jellyfin
  fowners jellyfin:jellyfin /etc/jellyfin
keepdir /var/cache/jellyfin
  fowners jellyfin:jellyfin /var/cache/jellyfin

  dodir ${INST_DIR}
  insinto ${INST_DIR}
  doins -r publish-output/*

  newinitd "${FILESDIR}"/jellyfin.init-r1 jellyfin
  newconfd "${FILESDIR}"/jellyfin.confd jellyfin
}
