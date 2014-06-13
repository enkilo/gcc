#---------------------------------------------------------------------------------
# Source and Install directories
#---------------------------------------------------------------------------------

THISDIR=`dirname "$0"`; cd "$THISDIR"

CC=`which ${CC-gcc}`

prefix=${CC%/bin/*}
build=`$CC -dumpmachine`

host=${1:-$build}

case "$host" in
  x86_64-*) host=i686-${host#*-} ;;
esac

echo "Building on $build for hosting on $host ..." 1>&2

if ! type $host-gcc 2>/dev/null >/dev/null; then
    echo "No $host-gcc, setting HOST_CFLAGS to -m32" 1>&2
    export HOST_CFLAGS="-m32"
fi
SRCDIR=../../gcc-3.4.6                      # the sourcecode dir for gcc
                                             # This must be specified in the format shown here
                                             # as one of the tools built during the process will fail
                                             # if absolute paths are specified
                                             # the example here assumes that the gcc source directory
                                             # is at the same level as the script

BUILDDIR=build/$host                          # installation directory
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

export HOST_CFLAGS="$HOST_CFLAGS -g -O2"
export HOST_CXXFLAGS="$HOST_CXXFLAGS -g -O2"
export HOST_LDFLAGS="-static"
export DEBUG_FLAGS=''

#---------------------------------------------------------------------------------
# build and install just the c compiler
#---------------------------------------------------------------------------------

[ -n "$MOSYNCDIR" -a -d "$MOSYNCDIR" ] && SYSROOT="$MOSYNCDIR" || SYSROOT="$prefix/$target"

mkdir -p "$BUILDDIR"
cd "$BUILDDIR"

(
(set -x
        CC="$CC" \
 "$SRCDIR"/configure \
        ${prefix+--prefix="$prefix"} \
        ${libexecdir+--libexecdir="$prefix/lib"} \
        --enable-languages=c,c++ \
        --with-gcc --with-stabs \
        --disable-shared --disable-threads --disable-win32-registry --disable-nls \
        --build="$build" \
        --host="$host" \
        --target="$target" \
        `[ "$SYSROOT" ] || echo --without-headers` \
        --program-prefix="$progpref" -v \
        --with-gxx-include-dir="/include/c++/3.4.6" \
        ${SYSROOT:+--with-sysroot="$SYSROOT"} \
        ) \
        2>&1 && 
echo "Configuration in $BUILDDIR. Now type build using:" 1>&2
) | tee gcc_configure.log

echo "
    make -C $BUILDDIR  \\
      CFLAGS_FOR_TARGET=\"-g -O\" NATIVE_SYSTEM_HEADER_DIR=\"/include\"
"

