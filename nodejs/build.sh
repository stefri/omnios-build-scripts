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

# Node.js needs objdump to be GNU binutils
PATH=$PATH:/usr/gnu/i386-pc-solaris2.11/bin
export PATH

PROG=nodejs
ARCHIVENAME=node
VER=0.10.32
VERHUMAN=$VER
PKG=runtime/nodejs
SUMMARY="evented I/O for v8 javascript"
DESC="Node.js is a platform built on Chrome's JavaScript runtime for easily building fast, scalable network applications. Node.js uses an event-driven, non-blocking I/O model that makes it lightweight and efficient, perfect for data-intensive real-time applications that run across distributed devices."

BUILD_DEPENDS_IPS="developer/versioning/git runtime/python-26"
RUN_DEPENDS_IPS="library/security/openssl library/zlib runtime/python-26
        shell/bash system/library/g++-4-runtime system/library/gcc-4-runtime
        system/library/math system/library"

BUILDDIR=$ARCHIVENAME-v$VER

MAKE=gmake
BUILDARCH=64
CC=gcc
CXX=g++
CFLAGS="-m64"
export CC CXX CFLAGS
CONFIGURE_OPTS="--shared-zlib --prefix=$PREFIX"
CONFIGURE_OPTS_64="--dest-cpu=x64"

init
download_source $PROG $ARCHIVENAME v$VER
patch_source
prep_build
build
make_isa_stub
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
