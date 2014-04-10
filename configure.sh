#!/bin/sh

#---------------------------------------------------------------------------------
# Source and Install directories
#---------------------------------------------------------------------------------
SRCDIR=$PWD/gcc-3.4.6                        # the sourcecode dir for gcc # This must be specified in the format shown here
                                             # as one of the tools built during the process will fail
                                             # if absolute paths are specified
                                             # the example here assumes that the gcc source directory
                                             # is at the same level as the script

push() {
  eval "shift; $1=\"\${$1:+\$$1
}\$*\""
}

[ $# -gt 0 ] || set -- -

for h in `ls /usr/bin/*-gcc | xargs -n1 basename | grep -v color | grep -v mapip |grep -v ^mingw |grep -v pc-mingw | sed 's,-gcc$,,'`
do
  case "$h" in
    *$1*) push HOSTS $h ;;
  esac
done

: ${build=`${CC-gcc} -dumpmachine`}

for host in $HOSTS; do
  (
  unset prefix
  case "$host" in
    *linux*) : sysroot=/usr/mapip/sys-root; : ${prefix=/usr} ;;
    *ygwin*) : sysroot=/usr/mapip/sys-root; : ${prefix=/usr} ;;
    *mingw*) prefix=/MoSync-4.0-Alpha progpref=; export LDFLAGS="-static" ;;
  esac

  #: ${sysroot=/usr/mapip/sys-root}
  #: ${build_sysroot=$sysroot}                           # installation directory
                                               # This must be specified in the format shown here
                                               # or gcc won't be able to find it's libraries and includes
                                               # if you move the installation

  #: ${host=$build}

  builddir=./build/${host}

  #---------------------------------------------------------------------------------
  # set the path for the installed binutils
  #---------------------------------------------------------------------------------

  #export PATH=${PATH}:/c/cross-gcc/mosync/bin

  #---------------------------------------------------------------------------------
  # set the target and compiler flags
  #---------------------------------------------------------------------------------

  target=mapip
  : ${progpref=mapip-}

  export CFLAGS='-g -O -pipe'
  export CXXFLAGS='-g -O -pipe'
  export LDFLAGS=''
  export DEBUG_FLAGS='-DDEBUG'

  #---------------------------------------------------------------------------------
  # build and install just the c compiler
  #---------------------------------------------------------------------------------

  mkdir -p $builddir

    {
      ( set -x
        cd $builddir

        $SRCDIR/configure \
                --enable-languages=c,c++ \
                --with-gcc --with-stabs \
                --disable-shared --disable-threads --disable-win32-registry --disable-nls \
            --prefix=$prefix \
            --libexecdir=$prefix/lib \
                --target=$target \
                ${build+--build=$build} \
                ${host+--host=$host} \
                ${sysroot+--with-sysroot=$sysroot} \
                ${build_sysroot+--with-build-sysroot=$build_sysroot} \
                --without-headers \
                ${progpref+--program-prefix=$progpref} -v \
            --enable-checking
      ) 2>&1  &&
      echo "make -C $builddir all-gcc 2>&1 | tee make_${host}.log" 
    } | tee gcc_configure_${host}.log
  ) &&
  push CONFIGURED_HOSTS $host

done

for h in $CONFIGURED_HOSTS; do
  echo "make -C build/$h all-gcc LDFLAGS="-static" HOST_LDFLAGS="-static" 2>&1 | tee make_${h}.log"
done |tee build.sh
