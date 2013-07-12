# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.md"

USE_RUBY="ruby19 ruby20"

inherit ruby-fakegem
DESCRIPTION="Delay Any task. Similar priority-queue."
HOMEPAGE="https://github.com/toshia/delayer"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

all_ruby_prepare() {
	# Remove bundler.
	sed -i -e '/bundler/d' Rakefile test/test_{delayer,priority}.rb
}
