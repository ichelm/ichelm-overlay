# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils flag-o-matic

DESCRIPTION="High-performance, two-pass large vocabulary continuous speech recognition"
HOMEPAGE="http://julius.sourceforge.jp/en_index.php"
SRC_URI="mirror://sourceforge.jp/${PN}/56549/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

LANGS="ja"

for LNG in ${LANGS}; do
	IUSE="${IUSE} linguas_${LNG}"
done

DEPEND=">=sys-libs/readline-4.1
	media-libs/alsa-lib
	media-libs/libsndfile
	sys-libs/zlib
	dev-perl/Jcode"

RDEPEND=${DEPEND}

src_prepare() {
	epatch "${FILESDIR}/${P}-makefile.patch"
}

src_configure() {
	append-flags "-fPIC"
	append-cppflags "-DHAVE_ZLIB"
	econf --disable-plugin --with-mictype=alsa --without-sndfile
}

src_install() {
	default

	dodoc 00readme.txt Release.txt || die

	for LNG in ${LINGUAS}; do
		dodoc 00readme-${LNG}.txt Release-${LNG}.txt || die
	done

	# /usr/bin/jcontrol collisions to java-config
	mv ${D}/usr/bin/jcontrol ${D}/usr/bin/julius-control
}
