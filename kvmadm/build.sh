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
# Copyright 2016 OmniTI Computer Consulting, Inc.  All rights reserved.
# Use is subject to license terms.
#
# Load support functions
. ../../lib/functions.sh

PROG=kvmadm
VER=0.9.3
VERHUMAN=$VER
PKG=system/kvmadm
SUMMARY="Manage KVM instances under SMF control"
DESC="Kvmadm takes care of setting up kvm instances on illumos derived operating systems with SMF support."

BUILDARCH=32
CONFIGURE_OPTS="--disable-svcimport"

make_install_extras() {
 logcmd /usr/bin/gsed -i 's#FindBin::RealBin/../lib#FindBin::RealBin/../../lib#g' $DESTDIR/$PREFIX/bin/$ISAPART/kvmadm ||
      logerr "------ Failed to patch kvmadm."
 logcmd /usr/bin/gsed -i 's#FindBin::RealBin/../lib#FindBin::RealBin/../../lib#g' $DESTDIR/$PREFIX/bin/$ISAPART/system-kvm ||
      logerr "------ Failed to patch system-kvm."

  logcmd mkdir -p $DESTDIR/lib/svc/manifest/system/ || \
      logerr "------ Failed to create manifest directory"
  logcmd mv $DESTDIR/usr/local/share/kvmadm/smf/system-kvm.xml $DESTDIR/lib/svc/manifest/system/system-kvm.xml || \
      logerr "------ Unable to move service manifest file"
  #logcmd rmdir $DESTDIR/usr/local/share/kvmadm/smf || \
  #logcmd rmdir $DESTDIR/usr/local/share/kvmadm || \
  #    logerr "------ Unable to remove shared kvmadm directory"
}

init
download_source $PROG $PROG $VER
patch_source
prep_build
build
make_install_extras
make_isa_stub
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
