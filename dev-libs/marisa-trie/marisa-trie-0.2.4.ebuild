# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python2_7 )
GENTOO_DEPEND_ON_PERL="no"

inherit eutils perl-module python-r1

DESCRIPTION="Matching Algorithm with Recursively Implemented StorAge"
HOMEPAGE="https://code.google.com/p/marisa-trie/"
SRC_URI="https://marisa-trie.googlecode.com/files/${P/-trie}.tar.gz"

LICENSE="|| ( LGPL-2.1+ BSD-2 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc perl python ruby sse2 sse3 ssse3 sse4 static-libs"

DEPEND="virtual/pkgconfig
	perl? ( dev-lang/perl[-build] )
	python? ( ${PYTHON_DEPS} )
	ruby? ( dev-lang/ruby:1.9 )"

S="${WORKDIR}/${P/-trie}"

src_prepare() {
	epatch "${FILESDIR}/${PN}-0.2.2-bindings.patch"
}

src_configure() {
	econf \
		$(use_enable sse2) \
		$(use_enable sse3) \
		$(use_enable ssse3) \
		$(use_enable sse4) \
		$(use_enable static-libs static)
}

src_compile() {
	default

	if use perl; then
		pushd bindings/perl
		rm sample.pl
		perl-module_src_configure
		perl-module_src_compile
		popd
	fi || die

	if use python; then
		pushd bindings/python
		python_foreach_impl python setup.py build
		popd
	fi || die

	if use ruby; then
		pushd bindings/ruby
		ruby19 extconf.rb && emake
		popd
	fi || die
}

src_install() {
	default

	if use perl; then
		pushd bindings/perl
		perl-module_src_install
		popd
	fi || die

	if use python; then
		pushd bindings/python
		python_foreach_impl python setup.py install --root="${D}"
		popd
	fi || die

	if use ruby; then
		pushd bindings/ruby
		emake DESTDIR="${D}" install
		popd
	fi || die
	prune_libtool_files
	if use doc; then
		dohtml docs/*
	fi
}
