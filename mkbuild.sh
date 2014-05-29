cat <<EOF| tee build.sh|sed "s/^/build.sh: /"

builddir=\${1-$builddir}

SRCDIR=gcc-3.4.6

mkdir -p \$builddir/gcc && cp -vf \$SRCDIR/gcc/{gengtype-yacc.c,c-parse.c,gengtype-lex.c} \$builddir/gcc

make -C \$builddir CFLAGS_FOR_BUILD="-g -Wall" CC_FOR_BUILD=gcc {HOST_,}LDFLAGS="-static" all-gcc

$host-strip -v --strip-all \$builddir/gcc/{xgcc,cpp,cc1,cc1plus}*

mkdir -p \${MOSYNCDIR:-$prefix}/{mapip/bin,bin} && 
cp -vf \$builddir/gcc/{xgcc,cpp}* \${MOSYNCDIR:-$prefix}/bin && 
cp -vf \$builddir/gcc/{cc1,cc1plus}* \${MOSYNCDIR:-$prefix}/mapip/bin

#ln -sf xgcc \${MOSYNCDIR:-$prefix}/bin/gcc
EOF