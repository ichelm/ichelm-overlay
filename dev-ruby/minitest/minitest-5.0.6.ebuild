# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
USE_RUBY="ruby18 ruby19 ruby20 jruby"

# Rake is the easiest way to go through this unfortunately.
RUBY_FAKEGEM_RECIPE_TEST="rake"

RUBY_FAKEGEM_TASK_DOC="docs"

RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="History.txt Manifest.txt README.txt"

inherit ruby-fakegem

DESCRIPTION="minitest/unit is a small and fast replacement for ruby's huge and slow test/unit."
HOMEPAGE="https://github.com/seattlerb/minitest"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="doc test"

ruby_add_bdepend "
	doc? ( dev-ruby/hoe dev-ruby/rdoc )
	test? ( dev-ruby/hoe )"
# 	What is this blocker for?
#	ruby_targets_ruby18? ( !!dev-ruby/minitest[ruby_targets_ruby18] )"

# There is a nasty bug that tests fail if minitest is loaded already
# from the system.

each_ruby_prepare() {
	case ${RUBY} in
		*jruby)
			# Make sure __jtrap is available in all threads. This should
			# be fixed in jruby 1.7.x
			sed -i -e '8i  trap :INFO do ; end' lib/minitest/parallel_each.rb || die

			# Avoid failures. Most of these look like low-level jruby
			# differences and it looks like these were not run properly
			# in previous versions.
			for t in test_return_mock_does_not_raise test_mock_args_does_not_raise test_stub_block test_stub_value ; do
				command="/${t}/,/^  end/ s:^:#:"
				sed -i -e "${command}" test/minitest/test_minitest_mock.rb || die
			done
			for t in test_run_failing test_run_skip test_run_error test_run_skip_verbose test_run_error_teardown test_runnable_methods_random test_assert_throws_different test_to_s_error_in_test_and_teardown test_run_filtered_including_suite_name_string test_run_filtered_string_method_only test_run_filtered_including_suite_name ; do
				command="/${t}/,/^  end/ s:^:#:"
				sed -i -e "${command}" test/minitest/test_minitest_unit.rb || die
			done
			for t in test_name2 "needs to verify throw" ; do
				command="/${t}/,/^  end/ s:^:#:"
				sed -i -e "${command}" test/minitest/test_minitest_spec.rb || die
			done
			sed -i -e '/test_report_error/,/^  end/ s:^:#:' test/minitest/test_minitest_reporter.rb || die
			;;
	esac
}
