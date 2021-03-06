# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit eutils

DESCRIPTION="IBus engine using libkkc"
HOMEPAGE="https://bitbucket.org/libkkc/libkkc/wiki/Home"
SRC_URI="https://bitbucket.org/libkkc/ibus-kkc/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=app-i18n/ibus-1.5
	>=app-i18n/libkkc-0.2.3
	dev-libs/json-glib
	x11-libs/gtk+:3"
RDEPEND="${DEPEND}"
