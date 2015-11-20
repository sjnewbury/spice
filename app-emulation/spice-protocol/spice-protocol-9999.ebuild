# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils autotools git-r3

DESCRIPTION="Headers defining the SPICE protocol"
HOMEPAGE="http://spice-space.org/"
#SRC_URI="http://spice-space.org/download/releases/${P}.tar.bz2"
EGIT_REPO_URI="git://git.freedesktop.org/git/spice/${PN}"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND=""

src_prepare() {
	default
	eautoreconf
}
