# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
USE_RUBY="ruby18 ruby19"

inherit ruby-ng-gnome2

DESCRIPTION="Ruby binding of GDK 3"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="${DEPEND} >=x11-libs/gtk+-3.4.2:3"
RDEPEND="${RDEPEND} >=x11-libs/gtk+-3.4.2:3"

ruby_add_bdepend ">=dev-ruby/ruby-glib2-${PV}
	>=dev-ruby/ruby-pango-${PV}"
ruby_add_rdepend ">=dev-ruby/ruby-gdkpixbuf2-${PV}
	>=dev-ruby/ruby-atk-${PV}"
