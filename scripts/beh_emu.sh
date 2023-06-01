#!/bin/bash

ASM=../prog/asm/asm
EMU=../prog/emu/emu
TEST_DIR=../prog/src/

$ASM $TEST_DIR$1 -o bin.out
$EMU bin.out > emulog

../prog/bin2readmemh/bin2readmemh bin.out > program.mem
make behout -f ../scripts/Makefile
vvp behout -vcd ../run/beh.vcd > behtmp
tail -n +2 behtmp > rtllog
if diff -s emulog rtllog ; then
    echo "emulator and rtl pass "$1" test" 
    else "emulator and rtl fail "$1" test";
fi
