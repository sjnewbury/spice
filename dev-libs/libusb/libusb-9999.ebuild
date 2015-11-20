# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libusb/libusb-1.0.8.ebuild,v 1.9 2010/10/12 16:44:02 armin76 Exp $

EAPI="5"

inherit multilib git-2 autotools

DESCRIPTION="Userspace access to USB devices"
HOMEPAGE="http://libusb.org/"
#SRC_URI="mirror://sourceforge/libusb/${P}.tar.bz2"
SRC_URI=

EGIT_REPO_URI=git://people.freedesktop.org/~jwrdegoede/libusb
#EGIT_BRANCH=usbredir
#EGIT_COMMIT=${EGIT_BRANCH}
EGIT_BOOTSTRAP="ln -s . m4; eautoreconf"

LICENSE="LGPL-2.1"
SLOT="1"
KEYWORDS=""
IUSE="debug doc +usbredir"

DEPEND="doc? ( app-doc/doxygen )"
RDEPEND=""

src_configure() {
	econf \
		$(use_enable debug debug-log)
}

src_compile() {
	default

	if use doc ; then
		cd doc
		emake docs || die "making docs failed"
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	# HACK !!! BUMP VERSION !!!
	sed -i -e 's:1\.0\.8:1\.0\.9:' "${D}"/usr/"$(get_libdir)"/pkgconfig/libusb-1.0.pc || die version bumped already?

	dodoc AUTHORS NEWS PORTING README THANKS TODO

	if use doc ; then
		insinto /usr/share/doc/${PF}/examples
		doins examples/*.c

		dohtml doc/html/*
	fi
}
