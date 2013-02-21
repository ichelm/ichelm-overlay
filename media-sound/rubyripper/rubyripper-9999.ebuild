# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
VIRTUALX_REQUIRED="always"
inherit ruby virtualx

DESCRIPTION="A secure audio ripper for linux"
HOMEPAGE="http://code.google.com/p/rubyripper"
SRC_URI=""
EGIT_REPO_URI="git://github.com/rubyripperdev/rubyripper.git"
EGIT_BRANCH="master"

inherit git


LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="cli flac +gtk +mp3 normalize +vorbis wav"

for lingua in $ILINGUAS; do
	IUSE="${IUSE} linguas_${lingua}"
done


RDEPEND="gtk? ( dev-ruby/ruby-gtk2
	>=dev-ruby/rcairo-1.8.0-r1[svg] )
	dev-ruby/ruby-gettext
	virtual/eject
	media-sound/cd-discid
	media-sound/cdparanoia
	flac? ( media-libs/flac )
	mp3? ( media-sound/lame )
	vorbis? ( media-sound/vorbis-tools )
	normalize? ( media-sound/normalize
	mp3? ( media-sound/mp3gain )
	vorbis? ( media-sound/vorbisgain )
	wav? ( media-sound/wavegain ) )"
DEPEND="${RDEPEND}"


#src_unpack() {
#	git_src_unpack
#}
	
src_configure() {
	local myconf="--prefix=/usr"
	local enable_linguas=""

	for lingua in $ILINGUAS; do
		use linguas_$lingua &&	enable_linguas="${enable_linguas},${lingua}"
	done

	[[ -n ${enable_linguas} ]] && myconf="${myconf}	--enable-lang=${enable_linguas#,}"

	use gtk && myconf="${myconf} --enable-gtk2"
	use cli && myconf="${myconf} --enable-cli"

	Xeconf ${myconf}
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
