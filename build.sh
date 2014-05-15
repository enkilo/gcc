mkdir -p ./build/gcc/gcc && cp -vf /home/enki/Sources/MoSync-gcc3/gcc-3.4.6/gcc/{gengtype-yacc.c,c-parse.c,gengtype-lex.c} ./build/gcc/gcc
make -C ./build/gcc HOST_LDFLAGS=-static LDFLAGS=-static
strip -v --strip-all ./build/gcc/gcc/{xgcc,cc1,cc1plus}
mkdir -p /opt/mosync/{mapip/bin,bin} && cp -vf ./build/gcc/gcc/xgcc /opt/mosync/bin && cp -vf ./build/gcc/gcc/cc1* /opt/mosync/mapip/bin
ln -sf xgcc /opt/mosync/bin/gcc
