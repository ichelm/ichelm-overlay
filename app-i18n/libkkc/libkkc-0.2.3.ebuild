# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python{2_6,2_7} )
VALA_MIN_API_VERSION="0.16"
VALA_USE_DEPEND="vapigen"

inherit autotools eutils python-any-r1 vala

DESCRIPTION="Japanese Kana Kanji conversion library"
HOMEPAGE="https://bitbucket.org/libkkc/libkkc/wiki/Home"
SRC_URI="https://bitbucket.org/libkkc/libkkc/downloads/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="introspection static-libs vala"
REQUIRED_USE="vala? ( introspection )"

DEPEND="${PYTHON_DEPS}
	dev-libs/json-glib
	dev-libs/libgee:0
	dev-libs/marisa-trie
	introspection? ( dev-libs/gobject-introspection )
	vala? ( $(vala_depend) )"
RDEPEND="${DEPEND}
	app-i18n/libkkc-data"

#src_prepare() {
#	epatch ${FILESDIR}/${P}-underlinking.patch
#	eautoreconf
#}

src_configure() {
	econf \
		$(use_enable introspection) \
		$(use_enable static-libs static) \
		$(use_enable vala)
}

src_install() {
	default
	prune_libtool_files
}
