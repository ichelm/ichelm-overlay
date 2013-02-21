# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
PYTHON_DEPEND="2"

inherit elisp-common python

DESCRIPTION="IBus client for GNU Emacs"
HOMEPAGE="https://launchpad.net/ibus.el"
SRC_URI="https://launchpad.net/ibus.el/0.3/0.3.2/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="virtual/emacs
	 dev-python/pygobject
	 dev-python/python-xlib
	 >=app-i18n/ibus-1.4[python]
	 !>=app-i18n/ibus-1.4.99"
DEPEND="${RDEPEND}"

SITEFILE=50${PN}-gentoo.el

pkg_setup() {
	python_pkg_setup
}

src_prepare() {
	sed -i 's|\(command\-name\)\ \"python\"|\1\ nil|' ibus.el
}

src_compile() {
	elisp-compile ibus.el
}

src_install() {
	python_convert_shebangs 2 ibus-el-agent
	dobin ibus-el-agent

	elisp-install ${PN} ibus.{el,elc}
	elisp-site-file-install "${FILESDIR}/${SITEFILE}" ${PN}

	dodoc README doc/ChangeLog doc/COPYING
}

pkg_postinst() {
	elisp-site-regen
}

pkg_postrm() {
	elisp-site-regen
}
