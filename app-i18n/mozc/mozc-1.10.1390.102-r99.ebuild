# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
PYTHON_COMPAT=( python{2_6,2_7} )
inherit elisp-common eutils multilib multiprocessing python-any-r1 toolchain-funcs

DESCRIPTION="The Mozc engine for IBus Framework"
HOMEPAGE="http://code.google.com/p/mozc/"

PROTOBUF_VER="2.5.0"
GMOCK_VER="1.6.0"
GTEST_VER="1.6.0"
JSONCPP_VER="0.6.0-rc2"
MOZC_URL="http://mozc.googlecode.com/files/${P}.tar.bz2"
PROTOBUF_URL="http://protobuf.googlecode.com/files/protobuf-${PROTOBUF_VER}.tar.bz2"
GMOCK_URL="https://googlemock.googlecode.com/files/gmock-${GMOCK_VER}.zip"
GTEST_URL="https://googletest.googlecode.com/files/gtest-${GTEST_VER}.zip"
JSONCPP_URL="mirror://sourceforge/jsoncpp/jsoncpp-src-${JSONCPP_VER}.tar.gz"
SRC_URI="${MOZC_URL}
	!system-protobuf? ( ${PROTOBUF_URL} )
	test? ( ${GMOCK_URL} ${GTEST_URL} ${JSONCPP_URL} )"

LICENSE="Apache-2.0 BSD Boost-1.0 ipadic public-domain unicode"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="emacs fcitx +ibus +qt4 renderer system-protobuf test uim"

RDEPEND="dev-libs/glib:2
	dev-libs/openssl
	x11-libs/libxcb
	emacs? ( virtual/emacs )
	ibus? ( >=app-i18n/ibus-1.4.1 )
	renderer? ( x11-libs/gtk+:2 )
	qt4? (
		dev-qt/qtgui:4
		app-i18n/zinnia
	)
	fcitx? ( app-i18n/fcitx )
	uim? ( app-i18n/uim )"

DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	system-protobuf? ( >=dev-libs/protobuf-2.4.1 )
	virtual/pkgconfig"

BUILDTYPE="${BUILDTYPE:-Release}"

RESTRICT="test"

SITEFILE=50${PN}-gentoo.el

src_unpack() {
	unpack $(basename ${MOZC_URL})

	if ! use system-protobuf; then
		cd "${S}"/protobuf
		unpack $(basename ${PROTOBUF_URL})
		mv protobuf-${PROTOBUF_VER} files || die
	fi

	if use test; then
		cd "${S}"/third_party
		unpack $(basename ${GMOCK_URL}) $(basename ${GTEST_URL}) \
			$(basename ${JSONCPP_URL})
		mv gmock-${GMOCK_VER} gmock || die
		mv gtest-${GTEST_VER} gtest || die
		mv jsoncpp-src-${JSONCPP_VER} jsoncpp || die
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-drop-Werror.patch
	epatch "${FILESDIR}"/${P}-use_libprotobuf.patch
	# Conditional patching is evil, fix later.
	use fcitx && epatch -p1 "${FILESDIR}"/${P}-fcitx.patch
	use uim  && epatch -p1 "${FILESDIR}"/${P}-uim.patch
	epatch_user
}

src_configure() {
	local myconf="--server_dir=/usr/$(get_libdir)/mozc"

	if ! use qt4 ; then
		myconf+=" --noqt"
		export GYP_DEFINES="use_libzinnia=0"
	fi

	if ! use renderer ; then
		export GYP_DEFINES="${GYP_DEFINES} enable_gtk_renderer=0"
	fi

	if use system-protobuf; then
		export GYP_DEFINES="${GYP_DEFINES} use_libprotobuf=1"
	fi

	"${PYTHON}" build_mozc.py gyp ${myconf} || die "gyp failed"
}

src_compile() {
	tc-export CC CXX AR AS RANLIB LD

	local my_makeopts=$(makeopts_jobs)
	# This is for a safety. -j without a number, makeopts_jobs returns 999.
	local myjobs=-j${my_makeopts/999/1}

	local mytarget="server/server.gyp:mozc_server"
	use emacs && mytarget="${mytarget} unix/emacs/emacs.gyp:mozc_emacs_helper"
	use ibus && mytarget="${mytarget} unix/ibus/ibus.gyp:ibus_mozc"
	use renderer && mytarget="${mytarget} renderer/renderer.gyp:mozc_renderer"
	use fcitx && mytarget="${mytarget} unix/fcitx/fcitx.gyp:fcitx-mozc"
	use uim && mytarget="${mytarget} unix/uim/uim.gyp:uim-mozc"
	if use qt4 ; then
		export QTDIR="${EPREFIX}/usr"
		mytarget="${mytarget} gui/gui.gyp:mozc_tool"
	fi

	V=1 "${PYTHON}" build_mozc.py build_tools -c "${BUILDTYPE}" ${myjobs} || die
	V=1 "${PYTHON}" build_mozc.py build -c "${BUILDTYPE}" ${mytarget} ${myjobs} || die

	if use emacs ; then
		elisp-compile unix/emacs/*.el || die
	fi
}

src_test() {
	tc-export CC CXX AR AS RANLIB LD
	V=1 "${PYTHON}" build_mozc.py runtests -c "${BUILDTYPE}" || die
}

src_install() {
	if use emacs ; then
		dobin "out_linux/${BUILDTYPE}/mozc_emacs_helper" || die
		elisp-install ${PN} unix/emacs/*.{el,elc} || die
		elisp-site-file-install "${FILESDIR}/${SITEFILE}" ${PN} || die
	fi

	if use ibus ; then
		exeinto /usr/libexec || die
		newexe "out_linux/${BUILDTYPE}/ibus_mozc" ibus-engine-mozc || die
		insinto /usr/share/ibus/component || die
		doins "out_linux/${BUILDTYPE}/obj/gen/unix/ibus/mozc.xml" || die
		insinto /usr/share/ibus-mozc || die
		(
			cd data/images/unix
			newins ime_product_icon_opensource-32.png product_icon.png || die
			for f in ui-*
			do
				newins ${f} ${f/ui-} || die
			done
		)
	fi

	if use fcitx ; then
		exeinto /usr/$(get_libdir)/fcitx
		doexe "out_linux/${BUILDTYPE}/fcitx-mozc.so"
		insinto /usr/share/fcitx/addon
		doins "unix/fcitx/fcitx-mozc.conf"
		insinto /usr/share/fcitx/inputmethod
		doins "unix/fcitx/mozc.conf"
		insinto /usr/share/fcitx/mozc/icon
		(
			cd data/images/unix || die
			newins ime_product_icon_opensource-32.png mozc.png
			for f in ui-*.png
			do
				newins ${f} ${f/ui/mozc}
			done
		)
		export MOPREFIX="fcitx-mozc"
		domo out_linux/${BUILDTYPE}/obj/gen/unix/fcitx/po/*.mo
	fi

	if use uim ; then
		exeinto "/usr/$(get_libdir)/uim/plugin"
		doexe "out_linux/${BUILDTYPE}/libuim-mozc.so"
		insinto "/usr/share/uim"
		doins unix/uim/scm/*
		insinto /usr/share/uim/pixmaps
		(
			cd data/images/unix || die
			newins ime_product_icon_opensource-32.png mozc.png
			newins ui-tool.png mozc_tool_config_dialog.png
			newins ui-dictionary.png mozc_tool_dictionary.png
			newins ui-properties.png mozc_tool_selector.png
		)
	fi

	exeinto "/usr/$(get_libdir)/mozc" || die
	doexe "out_linux/${BUILDTYPE}/mozc_server" || die

	if use qt4 ; then
		exeinto "/usr/$(get_libdir)/mozc" || die
		doexe "out_linux/${BUILDTYPE}/mozc_tool" || die
	fi

	if use renderer ; then
		exeinto "/usr/$(get_libdir)/mozc" || die
		doexe "out_linux/${BUILDTYPE}/mozc_renderer" || die
	fi
}

pkg_postinst() {
	if use emacs ; then
		elisp-site-regen
		elog "You can use mozc-mode via LEIM (Library of Emacs Input Method)."
		elog "Write the following settings into your init file (~/.emacs.d/init.el"
		elog "or ~/.emacs) in order to use mozc-mode by default, or you can call"
		elog "\`set-input-method' and set \"japanese-mozc\" anytime you have loaded"
		elog "mozc.el"
		elog
		elog "  (require 'mozc)"
		elog "  (set-language-environment \"Japanese\")"
		elog "  (setq default-input-method \"japanese-mozc\")"
		elog
		elog "Having the above settings, just type C-\\ which is bound to"
		elog "\`toggle-input-method' by default."
	fi

	if use uim ; then
		uim-module-manager --register mozc || die
		elog "mozc uim module is registered now."
		elog "But every merging app-i18n/uim breaks this registration."
		elog "Please re-emerge mozc or run following command by hand after uim merge."
		elog " uim-module-manager --register mozc"
		if use system-protobuf ; then
			ewarn "You have enabled both of system-protobuf and uim use flags."
			ewarn "But dynamicaly linked mozc_tool on uim is known to be broken."
			ewarn "mozc_tool will be not functional."
		fi
	fi
}

pkg_postrm() {
	use emacs && elisp-site-regen
	use uim && uim-module-manager --unregister mozc || die
}
