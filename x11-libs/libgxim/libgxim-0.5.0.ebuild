# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

DESCRIPTION="GObject-based XIM protocol library"
HOMEPAGE="tagoh.bitbucket.org/libgxim/"
SRC_URI="https://bitbucket.org/tagoh/libgxim/downloads/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc static-libs"

RDEPEND=">=dev-libs/check-0.9.4
	>=dev-libs/dbus-glib-0.74
	>=dev-libs/glib-2.32
	>=sys-apps/dbus-0.23"
DEPEND="${RDEPEND}
	dev-lang/ruby
	virtual/pkgconfig
	doc? ( >=dev-util/gtk-doc-1.8 )"

DOCS=( AUTHORS ChangeLog NEWS README )

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	prune_libtool_files
}
