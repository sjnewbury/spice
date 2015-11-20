# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python{3_3,3_4} pypy pypy3 )

inherit eutils python-any-r1 autotools git-r3

DESCRIPTION="SPICE server and client"
HOMEPAGE="http://spice-space.org/"
#SRC_URI="http://spice-space.org/download/releases/${P}.tar.bz2"
EGIT_REPO_URI="git://git.freedesktop.org/git/spice/${PN}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="client sasl smartcard static-libs" # static

# only the client links against libcacard, the libspice-server only uses the headers
# the client cannot be built statically since alsa and qemu[smartcard] are missing static-libs
RDEPEND=">=x11-libs/pixman-0.17.7[static-libs(+)?]
	>=dev-libs/glib-2.22:2[static-libs(+)?]
	>=media-libs/celt-0.5.1.1:0.5.1[static-libs(+)?]
	media-libs/opus[static-libs(+)?]
	dev-libs/openssl[static-libs(+)?]
	virtual/jpeg[static-libs(+)?]
	sys-libs/zlib[static-libs(+)?]
	sasl? ( dev-libs/cyrus-sasl[static-libs(+)?] )
	client? (
		media-libs/alsa-lib
		>=x11-libs/libXrandr-1.2
		x11-libs/libX11
		x11-libs/libXext
		>=x11-libs/libXinerama-1.0
		x11-libs/libXfixes
		x11-libs/libXrender
		smartcard? ( >=app-emulation/libcacard-0.1.2 )
	)"

DEPEND="virtual/pkgconfig
	$(python_gen_any_dep \
		'>=dev-python/pyparsing-1.5.6-r2[${PYTHON_USEDEP}]')
	smartcard? ( >=app-emulation/libcacard-0.1.2 )
	${RDEPEND}"

python_check_deps() {
	has_version ">=dev-python/pyparsing-1.5.6-r2[${PYTHON_USEDEP}]"
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && python-any-r1_pkg_setup
}

# maintainer notes:
# * opengl support is currently broken

src_prepare() {
	epatch_user
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		$(use_enable client) \
		$(use_with sasl) \
		$(use_enable smartcard) \
		--disable-gui \
		--disable-static-linkage
#		$(use_enable static static-linkage) \
}

src_install() {
	default
	use static-libs || prune_libtool_files
}
