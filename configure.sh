#---------------------------------------------------------------------------------
# Source and Install directories
#---------------------------------------------------------------------------------

#push() {
#  eval "shift; $1=\"\${$1:+\$$1
#}\$*\""
#}
#
#[ $# -gt 0 ] || set -- -
#
#for h in `ls /usr/bin/*-gcc* | xargs -n1 basename | grep -v color | grep -v mapip |grep -v ^mingw |grep -v pc-mingw | sed 's,-gcc.*$,,'`
#do
#  case "$h" in
#    *$1*) push HOSTS $h ;;
#  esac
#done
#
#: ${build=`${CC-gcc} -dumpmachine`}
#
#for host in $HOSTS; do
#  (
#  unset prefix
#  case "$host" in
#    *linux*) sysroot=/usr/mapip/sys-root prefix=/usr ;;
#    *ygwin*) sysroot=/usr/mapip/sys-root prefix=/usr ;;
#    *mingw*) prefix=/MoSync-4.0-Alpha progpref=; export LDFLAGS="-static" ;;
#  esac
#
#  #: ${sysroot=/usr/mapip/sys-root}
#  #: ${build_sysroot=$sysroot}                           # installation directory
#                                               # This must be specified in the format shown here
#                                               # or gcc won't be able to find it's libraries and includes
#                                               # if you move the installation
#
#  #: ${host=$build}
#
#  builddir=./build/${host}


#---------------------------------------------------------------------------------
# set the path for the installed binutils
#---------------------------------------------------------------------------------

#export PATH=${PATH}:/c/cross-gcc/mosync/bin

#---------------------------------------------------------------------------------
# set the target and compiler flags
#---------------------------------------------------------------------------------

target=mapip
host=$(${CC:-gcc} -dumpmachine)
#i686-redhat-linux
progpref=mapip-

export CFLAGS='-m32 -O2 -pipe'
export CXXFLAGS='-m32 -O2 -pipe'
export LDFLAGS='-s'
export DEBUG_FLAGS=''

SRCDIR=../../gcc-3.4.6                       # the sourcecode dir for gcc
                                             # This must be specified in the format shown here
                                             # as one of the tools built during the process will fail
                                             # if absolute paths are specified
                                             # the example here assumes that the gcc source directory
                                             # is at the same level as the script

builddir=build/${host}                       # build directory
                                             # This must be specified in the format shown here
                                             # or gcc won't be able to find it's libraries and includes
                                             # if you move the installation
build=`gcc -dumpmachine`

#---------------------------------------------------------------------------------
# build and install just the c compiler
#--------------------------------"-------------------------------------------------

mkdir -p $builddir
(set -x
cd $builddir

$SRCDIR/configure \
        --enable-languages="c,c++" \
        --with-gcc --with-stabs \
        --disable-shared --disable-threads --disable-win32-registry --disable-nls \
        --target=$target \
        --host=$host \
        --build=$build \
        --without-headers \
        --program-prefix=$progpref -v \
        2>&1 | tee gcc_configure.log
)

. mkbuild.sh
