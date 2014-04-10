#!/bin/bash

BIN=${MOSYNCDIR:-/opt/mosync}/bin
LIB=${MOSYNCDIR:-/opt/mosync}/libexec/gcc

echo $BIN

mkdir -p $BIN
mkdir -p $LIB

cp build/gcc/gcc/xgcc $BIN
cp build/gcc/gcc/cpp $BIN
cp build/gcc/gcc/cc1 $LIB
cp build/gcc/gcc/cc1plus $LIB

echo installation complete.

