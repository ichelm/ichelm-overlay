# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
USE_RUBY="ruby18 ruby19"

inherit ruby-ng-gnome2

DESCRIPTION="Ruby binding of cairo-gobject"
KEYWORDS="~amd64 ~x86"
IUSE=""

RUBY_S=ruby-gnome2-all-${PV}/cairo-gobject

ruby_add_bdepend "dev-ruby/pkg-config
	dev-ruby/rcairo"
