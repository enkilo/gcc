#!/bin/sh

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

: ${prefix=/opt/mosync}                         # installation directory
                                             # This must be specified in the format shown here
                                             # or gcc won't be able to find it's libraries and includes
                                             # if you move the installation

: ${CC=gcc}
: ${build=`$CC -dumpmachine`}
: ${host=$build}

builddir=./build/gcc

#---------------------------------------------------------------------------------
# set the path for the installed binutils
#---------------------------------------------------------------------------------

#export PATH=${PATH}:/c/cross-gcc/mosync/bin

#---------------------------------------------------------------------------------
# set the target and compiler flags
#---------------------------------------------------------------------------------

target=mapip
progpref=mapip-



export CC
export CFLAGS='-O2 -pipe -m32'
export CXXFLAGS='-O2 -pipe -m32'
export {HOST_,}LDFLAGS='-static'
export DEBUG_FLAGS=''

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

{
echo "mkdir -p $builddir/gcc && cp -vf $SRCDIR/gcc/{gengtype-yacc.c,c-parse.c,gengtype-lex.c} $builddir/gcc"
echo make -C $builddir {HOST_,}LDFLAGS="-static" 
echo "strip -v --strip-all $builddir/gcc/{xgcc,cc1,cc1plus}"
echo "mkdir -p $prefix/{mapip/bin,bin} && cp -vf $builddir/gcc/xgcc $prefix/bin && cp -vf $builddir/gcc/cc1* $prefix/mapip/bin"
echo "ln -sf xgcc $prefix/bin/gcc"
} |tee build.sh
