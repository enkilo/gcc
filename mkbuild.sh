cat <<EOF| tee build.sh|sed "s/^/build.sh: /"

builddir=\${1-$builddir}

MOSYNCDIR=$prefix
SRCDIR=gcc-3.4.6
CFLAGS="$CFLAGS"
LDFLAGS="$LDFLAGS"

mkdir -p \$builddir/gcc && cp -vf \$SRCDIR/gcc/{gengtype-yacc.c,c-parse.c,gengtype-lex.c} \$builddir/gcc

make -C \$builddir CFLAGS_FOR_BUILD="\$CFLAGS" CC_FOR_BUILD=gcc {HOST_,}LDFLAGS="\$LDFLAGS" all-gcc

cat <<EOF2 |tee inst.sh|sed "s/^/inst.sh: /"
builddir=\\\${1-$builddir}
MOSYNCDIR=\$prefix

mkdir -p "\\\$DESTDIR\\\$MOSYNCDIR"/{mapip/bin,bin} && 
cp -vf \\\$builddir/gcc/{xgcc,cpp} "\\\$DESTDIR\\\$MOSYNCDIR/bin" && 
cp -vf \\\$builddir/gcc/{cc1,cc1plus} "\\\$DESTDIR\\\$MOSYNCDIR/mapip/bin"

#$host-strip -v --strip-all "\\\$DESTDIR\\\$MOSYNCDIR"/{bin/{xgcc,cpp},mapip/bin/{cc1,cc1plus}

EOF2

#ln -sf xgcc \${MOSYNCDIR:-$prefix}/bin/gcc
EOF
