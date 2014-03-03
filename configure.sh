#---------------------------------------------------------------------------------
# Source and Install directories
#---------------------------------------------------------------------------------

THISDIR=`dirname "$0"`; cd "$THISDIR"

CC=`which ${CC-gcc}`

prefix=${CC%/bin/*}
build=`$CC -dumpmachine`

#case "$build" in
#  x86_64-*) CFLAGS="-m32" build=i686-${build#*-} ;;
#esac

: ${host=$build}

echo "Building on $build for hosting on $host ..." 1>&2

SRCDIR=../../gcc-3.4.6                      # the sourcecode dir for gcc
                                             # This must be specified in the format shown here
                                             # as one of the tools built during the process will fail
                                             # if absolute paths are specified
                                             # the example here assumes that the gcc source directory
                                             # is at the same level as the script

BUILDDIR=build/$build                          # installation directory
                                             # This must be specified in the format shown here
                                             # or gcc won't be able to find it's libraries and includes
                                             # if you move the installation


#---------------------------------------------------------------------------------
# set the path for the installed binutils
#---------------------------------------------------------------------------------

#export PATH=${PATH}:/c/cross-gcc/mosync/bin

#---------------------------------------------------------------------------------
# set the target and compiler flags
#---------------------------------------------------------------------------------

target=mapip
progpref=mapip-

export CFLAGS="$CFLAGS -g -O2 -pipe"
export CXXFLAGS="$CXXFLAGS -g -O2 -pipe"
export LDFLAGS=""
export DEBUG_FLAGS=''

#---------------------------------------------------------------------------------
# build and install just the c compiler
#---------------------------------------------------------------------------------

if [ -n "$MOSYNCDIR" -a -d "$MOSYNCDIR" ]; then
  SYSROOT="$MOSYNCDIR"
else
  SYSROOT="$prefix/$target"
fi

mkdir -p "$BUILDDIR"
cd "$BUILDDIR"

"$SRCDIR"/configure \
        ${prefix+--prefix="$prefix"} \
        --enable-languages=c,c++ \
        --with-gcc --with-stabs \
        --disable-shared --disable-threads --disable-win32-registry --disable-nls \
        --build="$build" \
        --host="$host" \
        --target="$target" \
        --without-headers \
        --program-prefix="$progpref" -v \
        ${SYSROOT+--with-sysroot="$SYSROOT"} \
        "$@" \
        2>&1 | tee gcc_configure.log

echo "Configuration in $BUILDDIR. Now type build using:" 1>&2

echo "
    make -C $BUILDDIR  \\
      CFLAGS_FOR_TARGET=\"-g -O2\" NATIVE_SYSTEM_HEADER_DIR=\"/include\"
"

