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


PATH=/usr/gnu/bin:$PATH

PROG=libvpx
VER=1.2.0
PKG=library/libvpx
SUMMARY="WebM VP8/VP9 Codec"
DESC="$SUMMARY ($VER)"

BUILDDIR=$PROG-v$VER
NO_PARALLEL_MAKE=1

CONFIGURE_OPTS_32="--prefix=$PREFIX
    --libdir=$PREFIX/lib"

CONFIGURE_OPTS_64="--prefix=$PREFIX
    --libdir=$PREFIX/lib/$ISAPART64"

CONFIGURE_OPTS="--enable-shared \
    --disable-install-bins \
    --disable-examples \
    --disable-docs"

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
