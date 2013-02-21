# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

RUBY_FAKEGEM_EXTRADOC="README"

USE_RUBY="jruby ruby18 ruby19"

inherit ruby-fakegem
DESCRIPTION="A Ruby library that lets you memoize methods"
HOMEPAGE="http://github.com/djberg96/memoize"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/test-unit:2 ) "
