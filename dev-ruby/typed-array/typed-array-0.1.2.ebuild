# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.rdoc"
#  Actualy there is no test. "rake test" just got the error.
RUBY_FAKEGEM_RECIPE_TEST=""

USE_RUBY="jruby ruby18 ruby19"

inherit ruby-fakegem
DESCRIPTION="Gem provides enforced-type functionality to Arrays"
HOMEPAGE="http://github.com/yaauie/typed-array"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

all_ruby_prepare() {
	# There is a trash...
	rm ${S}/lib/typed-array/.DS_Store
}
