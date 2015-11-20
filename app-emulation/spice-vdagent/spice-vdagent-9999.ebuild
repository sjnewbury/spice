# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/spice-vdagent/spice-vdagent-0.8.0.ebuild,v 1.1 2011/05/11 09:02:31 dev-zero Exp $

EAPI=4

inherit linux-info autotools git-2 systemd

DESCRIPTION="SPICE VD Linux Guest Agent."
HOMEPAGE="http://spice-space.org/"
SRC_URI=""
EGIT_REPO_URI="git://git.freedesktop.org/git/spice/linux/vd_agent"
EGIT_BOOTSTRAP="eautoreconf"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="consolekit systemd"

RDEPEND="x11-libs/libXfixes
	x11-libs/libXrandr
	x11-libs/libX11
	>=app-emulation/spice-protocol-9999
	consolekit? ( sys-auth/consolekit sys-apps/dbus )"
DEPEND="dev-util/pkgconfig
	${RDEPEND}"

CONFIG_CHECK="INPUT_UINPUT"
ERROR_INPUT_UINPUT="User level driver support is required to run the spice-vdagent daemon"

src_configure() {
	local myeconfargs+=(
		--localstatedir=/var
		$(use_enable consolekit console-kit)
	)

	use systemd && myeconfargs+=(
		--with-session-info=systemd
		--with-init-script=systemd
	)
	
	econf ${myeconfargs[@]}
}

src_install() {
	default

	rm -rf "${D}"/etc/{rc,tmpfiles}.d

	keepdir /var/run/spice-vdagentd
	keepdir /var/log/spice-vdagentd

	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"

	#systemd_dounit spice-vdagentd.service || die
}

pkg_postinst() {
	elog "Make sure that the User level driver support kernel module 'uinput' is loaded"
	elog "if built as a module before starting the vdagent daemon."
}
