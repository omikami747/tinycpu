#!/bin/bash

ASM=../prog/asm/asm
EMU=../prog/emu/emu
TEST_DIR=../prog/src/

if [[ $1 == "-h" ]]; then
    echo "This script generates log files for both the emulator and structural models and compares them against each other to measure correctness for a particular test, the first argument provided should be the test code file that is present in the ../prog/src/ directory";
else
    if test -e $TEST_DIR$1 ; then
	$ASM $TEST_DIR$1 -o bin.out
	$EMU bin.out > emulog
	
	../prog/bin2readmemh/bin2readmemh bin.out > program.mem
	make structout -f ../scripts/Makefile
	vvp structout -vcd beh.vcd > structtmp
	tail -n +2 structtmp > structurallog
	if diff -s emulog structurallog ; then
	    echo "emulator and structural pass "$1" test"; 
	else "emulator and structural fail "$1" test";
	fi;
    else echo "Invalid Test name, please try again with a valid test";
    fi;
fi
