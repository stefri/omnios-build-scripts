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
# Copyright 2015 OmniTI Computer Consulting, Inc.  All rights reserved.
# Use is subject to license terms.
#
# Load support functions
. ../../lib/functions.sh

PROG=openssl
VER=1.0.2
VERHUMAN=$VER
PKG=mawi/library/security/openssl
SUMMARY="$PROG - A toolkit for Secure Sockets Layer (SSL v2/v3) and Transport Layer (TLS v1) protocols and general purpose cryptographic library"
DESC="$SUMMARY ($VER)"

RUN_DEPENDS_IPS="system/library/gcc-4-runtime local/library/zlib@1.2.8"

REMOVE_PREVIOUS=1
NO_PARALLEL_MAKE=1
SSLPLAT=solaris-x86-gcc

configure32() {
    logmsg "--- Configure (32-bit) $SSLPLAT"
    logcmd ./Configure $SSLPLAT --pk11-libname=/usr/lib/libpkcs11.so.1 shared threads zlib enable-md2 --prefix=$PREFIX ||
        logerr "Failed to run configure"
    SHARED_LDFLAGS="-shared -Wl,-z,text"
}

configure64() {
    logmsg "--- Configure (64-bit) $SSLPLAT"
    logcmd ./Configure $SSLPLAT --pk11-libname=/usr/lib/64/libpkcs11.so.1 shared threads zlib enable-md2 \
        --prefix=$PREFIX ||
        logerr "Failed ot run configure"
    SHARED_LDFLAGS="-m64 -shared -Wl,-z,text"
}

make_prog() {
    [[ -n $NO_PARALLEL_MAKE ]] && MAKE_JOBS=""
    logmsg "--- make"
    # This will setup the internal runpath of libssl and libcrypto
    logcmd $MAKE $MAKE_JOBS SHARED_LDFLAGS="$SHARED_LDFLAGS" || \
        logerr "--- Make failed"
    logmsg "--- make test"
    logcmd $MAKE test || \
        logerr "--- make test failed"
}

make_install() {
    logmsg "--- make install"
    logcmd make INSTALL_PREFIX=$DESTDIR install ||
        logerr "Failed to make install"
}

# Turn the letter component of the version into a number for IPS versioning
ord26() {
    local ASCII=$(printf '%d' "'$1")
    ASCII=$((ASCII - 64))
    [[ $ASCII -gt 32 ]] && ASCII=$((ASCII - 32))
    echo $ASCII
}
save_function make_package make_package_orig
make_package() {
    if [[ -n "`echo $VER | grep [a-z]`" ]]; then
        NUMVER=${VER::$((${#VER} -1))}
        ALPHAVER=${VER:$((${#VER} -1))}
        VER=${NUMVER}.$(ord26 ${ALPHAVER})
    fi

    make_package_orig
}

init
download_source $PROG $PROG $VER
patch_source
prep_build
build
make_isa_stub
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
