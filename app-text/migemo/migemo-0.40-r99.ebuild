# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/migemo/migemo-0.40-r4.ebuild,v 1.8 2010/09/27 11:02:27 xmw Exp $

EAPI=4

USE_RUBY="ruby18"

inherit autotools elisp-common eutils ruby-ng

DESCRIPTION="Migemo is Japanese Incremental Search Tool"
HOMEPAGE="http://0xcc.net/migemo/"
SRC_URI="http://0xcc.net/migemo/stable/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="emacs"

DEPEND="app-dicts/migemo-dict[-unicode]
	emacs? ( virtual/emacs
		app-emacs/apel )"
RDEPEND="${DEPEND}"

ruby_add_bdepend "dev-ruby/ruby-romkan
	dev-ruby/ruby-bsearch"

SITEFILE="50${PN}-gentoo.el"
RUBY_PATCHES=(
	"${FILESDIR}/${P}-without-emacs.patch"
	"${FILESDIR}/migemo_ruby-ng.patch"
)

all_ruby_prepare() {
	cp "${ROOT}"/usr/share/migemo/migemo-dict .
	eautoreconf
}

each_ruby_configure() {
	RUBY="${RUBY}" econf $(use_with emacs) --with-lispdir="${SITELISP}/${PN}"
}

each_ruby_compile() {
	emake -j1 || die
}

each_ruby_install() {
	emake -j1 DESTDIR="${D}" \
		$(use emacs || echo "lispdir=") install || die

	rm "${D}"/usr/share/migemo/migemo-dict

	if use emacs; then
		elisp-site-file-install "${FILESDIR}/${SITEFILE}" || die
	fi
	dodoc AUTHORS ChangeLog INSTALL README
}

pkg_postinst() {
	if use emacs; then
		elisp-site-regen
		elog "Migemo adviced search is no longer enabled as a site default."
		elog "Add the following line to your ~/.emacs file to enable it:"
		elog "  (require 'migemo)"
	fi
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
