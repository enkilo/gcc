#!/bin/bash

#---------------------------------------------------------------------------------
# Source and Install directories
#---------------------------------------------------------------------------------

while :; do
  ARG=$1
  case "$ARG" in
    --) shift; break ;;
    *=*) ARG=${ARG#--}; eval "${ARG%%=*}='${ARG#*=}'"; shift ;;
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

if type "$host-gcc"; then
  CC=$host-gcc
fi

export CC
export CFLAGS='-O2 -pipe'
export CXXFLAGS='-O2 -pipe'
export {HOST_,}LDFLAGS='-static'
export DEBUG_FLAGS=''


if [ "$host" != "$build" ]; then
  
  echo "$host" $build
  unset CC
  export CC=gcc
  CFLAGS="$CFLAGS -m32"
  CXXFLAGS="$CFLAGS -m32"
fi

#---------------------------------------------------------------------------------
# build and install just the c compiler
#---------------------------------------------------------------------------------
(mkdir -p $builddir
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
  ) 2>&1 | tee gcc_configure.log

. mkbuild.sh

