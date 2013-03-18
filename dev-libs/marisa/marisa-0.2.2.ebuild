# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit eutils

DESCRIPTION="Matching Algorithm with Recursively Implemented StorAge"
HOMEPAGE="https://code.google.com/p/marisa-trie/"
SRC_URI="https://marisa-trie.googlecode.com/files/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc sse2 sse3 ssse3 sse4 static-libs"

DEPEND="virtual/pkgconfig"

src_configure() {
	econf \
		$(use_enable sse2) \
		$(use_enable sse3) \
		$(use_enable ssse3) \
		$(use_enable sse4) \
		$(use_enable static-libs static)
}

src_install() {
	default
	prune_libtool_files
	if use doc; then
		dohtml docs/*
	fi
}
