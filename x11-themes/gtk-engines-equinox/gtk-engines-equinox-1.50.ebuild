# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit eutils

DESCRIPTION="Equinox GTK+2 Engine based on Aurora"
SRC_URI="http://gnome-look.org/CONTENT/content-files/121881-equinox-${PV}.tar.gz"

HOMEPAGE="http://gnome-look.org/content/show.php?content=121881"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="static-libs"

RDEPEND="x11-libs/gtk+:2
	x11-libs/cairo
	x11-libs/pixman"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

S="${WORKDIR}/equinox-${PV}"

src_configure() {
	econf \
		--enable-animation \
		$(use_enable static-libs static) \
		--disable-dependency-tracking || die "econf failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS NEWS README
}
