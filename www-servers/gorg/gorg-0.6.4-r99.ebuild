#

EAPI="4"

USE_RUBY="ruby18 ruby19"

inherit eutils ruby-ng

DESCRIPTION="Back-end XSLT processor for an XML-based web site"
HOMEPAGE="http://www.gentoo.org/proj/en/gdp/doc/gorg.xml"
SRC_URI="http://gentoo.neysx.org/mystuff/gorg/${P}.tgz"
IUSE="fastcgi mysql"

SLOT="0"
USE_RUBY="ruby18 ruby19"
LICENSE="GPL-2"
KEYWORDS=""

DEPEND="
		>=dev-libs/libxml2-2.6.16
		>=dev-libs/libxslt-1.1.12"
RDEPEND="${DEPEND}
		mysql? ( >=dev-ruby/ruby-dbi-0.0.21[mysql] )
		fastcgi? (
				virtual/httpd-fastcgi
				>=dev-ruby/ruby-fcgi-0.8.5-r1
		)"

RUBY_PATCHES=(
	"${FILESDIR}"/${P}-ruby19.patch
	"${FILESDIR}"/${P}-ruby19-date.patch
	"${FILESDIR}"/${P}-each_line.patch
)

pkg_setup() {
		enewgroup gorg
		enewuser  gorg -1 -1 -1 gorg
}

each_ruby_configure() {
	${RUBY} setup.rb config || die
}

each_ruby_compile() {
	${RUBY} setup.rb setup || die
}

each_ruby_install() {
	${RUBY} setup.rb install --prefix="${D}" || die
	# install doesn't seem to chmod these correctly, forcing it here
	SITE_LIB_DIR="$(ruby_rbconfig_value 'sitelibdir')"
	chmod +x "${D}"/${SITE_LIB_DIR}/gorg/cgi-bin/*.cgi
	chmod +x "${D}"/${SITE_LIB_DIR}/gorg/fcgi-bin/*.fcgi
}

all_ruby_install() {
	keepdir /etc/gorg; insinto /etc/gorg ; doins etc/gorg/*
	diropts -m0770 -o gorg -g gorg; keepdir /var/cache/gorg
	dodoc Changelog README
}
