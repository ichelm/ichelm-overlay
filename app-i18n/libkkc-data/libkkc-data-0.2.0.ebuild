# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit python-any-r1

DESCRIPTION="Language model data for libkkc"
HOMEPAGE="https://bitbucket.org/libkkc/libkkc/wiki/Home"
SRC_URI="https://bitbucket.org/libkkc/libkkc-data/downloads/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="${PYTHON_DEPS}
	dev-libs/marisa-trie[python]"

DEPEND="${RDEPEND}
	${PYTHON_DEPS}"

src_configure() {
	PYTHON=${PYTHON} econf
}

src_compile() {
	emake -j1
}
