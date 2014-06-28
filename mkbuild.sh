cat <<EOF| tee build.sh|sed "s/^/build.sh: /"

builddir=\${1-$builddir}

MOSYNCDIR=$prefix
SRCDIR=gcc-3.4.6

mkdir -p \$builddir/gcc && cp -vf \$SRCDIR/gcc/{gengtype-yacc.c,c-parse.c,gengtype-lex.c} \$builddir/gcc

make -C \$builddir CFLAGS_FOR_BUILD="-g -Wall" CC_FOR_BUILD=gcc {HOST_,}LDFLAGS="-static" all-gcc

$host-strip -v --strip-all \$builddir/gcc/{xgcc,cpp,cc1,cc1plus}*

cat <<EOF2 |tee inst.sh|sed "s/^/inst.sh: /"
builddir=\\\${1-$builddir}
MOSYNCDIR=\$prefix

mkdir -p "\\\$DESTDIR\\\$MOSYNCDIR"/{mapip/bin,bin} && 
cp -vf \\\$builddir/gcc/{xgcc,cpp} "\\\$DESTDIR\\\$MOSYNCDIR/bin" && 
cp -vf \\\$builddir/gcc/{cc1,cc1plus} "\\\$DESTDIR\\\$MOSYNCDIR/mapip/bin"
EOF2

#ln -sf xgcc \${MOSYNCDIR:-$prefix}/bin/gcc
EOF
