#!/bin/bash

#---------------------------------------------------------------------------------
# Source and Install directories
#---------------------------------------------------------------------------------

while :; do
  ARG=$1
  case "$ARG" in
    --) shift; break ;;
    --*) ARGS="${ARGS+$ARGS${IFS}}$1"; shift ;;
    *=*) eval "${VAR%%=*}='${VAR#*=}'"; shift ;;
    *) break ;;
  esac
done

SRCDIR=$PWD/gcc-3.4.6                        # the sourcecode dir for gcc
                                             # This must be specified in the format shown here
                                             # as one of the tools built during the process will fail
                                             # if absolute paths are specified
                                             # the example here assumes that the gcc source directory
                                             # is at the same level as the script

: ${prefix=${MOSYNCDIR:-/opt/mosync}}                         # installation directory
                                             # This must be specified in the format shown here
                                             # or gcc won't be able to find it's libraries and includes
                                             # if you move the installation

: ${CC=gcc}
: ${build=`$CC -dumpmachine`}
: ${host=`echo "$build" | sed s/x86_64/i686/`}

builddir=./build/$host

#---------------------------------------------------------------------------------
# set the path for the installed binutils
#---------------------------------------------------------------------------------

#export PATH=${PATH}:/c/cross-gcc/mosync/bin

#---------------------------------------------------------------------------------
# set the target and compiler flags
#---------------------------------------------------------------------------------

target=mapip
progpref=mapip-

#if type "$host-${CC-gcc}"; then
#  CC=$host-${CC-gcc}
#fi

export CC
export CFLAGS='-g -ggdb -O0'
export CXXFLAGS='-g -ggdb -O0'
#export {HOST_,}LDFLAGS='-static'
export DEBUG_FLAGS='-g -ggdb -O0'


if [ "$host" != "$build" ]; then
  #echo "$host" $build
  CFLAGS="$CFLAGS -m32"
  CXXFLAGS="$CFLAGS -m32"
fi

#---------------------------------------------------------------------------------
# build and install just the c compiler
#---------------------------------------------------------------------------------
(mkdir -p $builddir
set -x
cd $builddir
$SRCDIR/configure \
        --enable-languages=c,c++ \
        --with-gcc --with-stabs \
        --disable-shared --disable-threads --disable-win32-registry --disable-nls \
	--prefix=$prefix \
	--libexecdir=$prefix/lib \
        --target=$target \
        --without-headers \
        --program-prefix=$progpref -v \
	--build=$build \
	--host=$host \
  $ARGS) 2>&1 | tee gcc_configure.log

. mkbuild.sh

