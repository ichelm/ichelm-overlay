# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
USE_RUBY="ruby18 ruby19"

inherit ruby-ng-gnome2

DESCRIPTION="Ruby bindings for gtksourceview"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="${RDEPEND}
	x11-libs/gtksourceview:3.0"
DEPEND="${DEPEND}
	x11-libs/gtksourceview:3.0"

ruby_add_bdepend ">=dev-ruby/ruby-gdk3-${PV}"
ruby_add_rdepend ">=dev-ruby/ruby-gtk3-${PV}"
