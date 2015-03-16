#!/usr/bin/bash
#
# CDDL HEADER START
#
# The contents of this file are subject to the terms of the
# Common Development and Distribution License, Version 1.0 only
# (the "License").  You may not use this file except in compliance
# with the License.
#
# You can obtain a copy of the license at usr/src/OPENSOLARIS.LICENSE
# or http://www.opensolaris.org/os/licensing.
# See the License for the specific language governing permissions
# and limitations under the License.
#
# When distributing Covered Code, include this CDDL HEADER in each
# file and include the License file at usr/src/OPENSOLARIS.LICENSE.
# If applicable, add the following below this CDDL HEADER, with the
# fields enclosed by brackets "[]" replaced with your own identifying
# information: Portions Copyright [yyyy] [name of copyright owner]
#
# CDDL HEADER END
#
#
# Copyright 2011-2012 OmniTI Computer Consulting, Inc.  All rights reserved.
# Use is subject to license terms.
#
# Load support functions
. ../../lib/functions.sh

PROG=Python
VER=2.7.8
VERHUMAN=$VER
PKG=runtime/python-27
SUMMARY="$PROG - An Interpreted, Interactive, Object-oriented, Extensible Programming Language."
DESC="$SUMMARY"

RUN_DEPENDS_IPS="system/library/gcc-4-runtime"

PREFIX=/opt/python27
BUILDARCH=64

CFLAGS="-O3"
CXXFLAGS="-O3"
CPPFLAGS="-D_REENTRANT"
LDFLAGS64="$LDFLAGS64 -L/opt/python26/lib/$ISAPART64 -R/opt/python26/lib/$ISAPART64"

CONFIGURE_OPTS="--with-system-ffi
                --enable-shared
		"
CONFIGURE_OPTS_64="--prefix=$PREFIX
                   --sysconfdir=$PREFIX/etc
                   --includedir=$PREFIX/include
                   --bindir=$PREFIX/bin
                   --sbindir=$PREFIX/sbin
                   --libdir=$PREFIX/lib
                   --libexecdir=$PREFIX/libexec
                   "

build() {
    CC="$CC $CFLAGS $CFLAGS64" \
    CXX="$CXX $CXXFLAGS $CXXFLAGS64" \
    build64
}

save_function configure64 configure64_orig
configure64() {
    configure64_orig
    logmsg "--- Fixing pyconfig.h so _socket.so builds"
    perl -pi'*.orig' -e 's/#define (HAVE_NETPACKET_PACKET_H) 1/#undef \1/' \
        pyconfig.h || logerr "Failed to fix pyconfig.h"
}

init
download_source python $PROG $VER
patch_source
prep_build
build
make_package
clean_up
