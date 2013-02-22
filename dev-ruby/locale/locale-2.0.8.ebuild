# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

USE_RUBY="ruby18 ruby19 jruby"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="ChangeLog README.rdoc doc.orig/text/news.md"

RUBY_FAKEGEM_RECIPE_TEST=""

inherit ruby-fakegem

DESCRIPTION="A pure ruby library which provides basic APIs for localization."
HOMEPAGE="http://ruby-gettext.github.com/"
LICENSE="|| ( Ruby GPL-2 )"

KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/test-unit:2 )"

all_ruby_prepare() {
	# Why is run-test.rb is missing on gem!?
	# Hackish. fix later.
	cp "${FILESDIR}"/run-test.rb test
	mv doc doc.orig
}

each_ruby_test() {
	${RUBY} test/run-test.rb || die "tests failed"
}

all_ruby_install() {
	all_fakegem_install

	insinto /usr/share/doc/${PF}
	doins -r samples || die
}
