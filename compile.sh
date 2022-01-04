#!/bin/sh

# test for xm2tiatune in current working directory and then execution path
TEST=./xm2tiatune
if [ -x "$TEST" ]; then
	XM2TIATUNE=$TEST
else
	TEST=./xm2tiatune_src/target/debug/xm2tiatune
	if [ -x "$TEST" ]; then
		XM2TIATUNE=$TEST
	else
		TEST=xm2tiatune
		command -v "$TEST" >/dev/null 2>&1 || { echo "*** could not fine xm2tiatune" >&2; exit 10; }
		XM2TIATUNE=$TEST
	fi
fi

# test for acme in current working directory and then execution path
TEST=./acme
if [ -x "$TEST" ]; then
	ACME=$TEST
else
	TEST=acme
	command -v "$TEST" >/dev/null 2>&1 || { echo "*** could not fine acme" >&2; exit 10; }
	ACME=$TEST
fi

# test for stella in execution path
TEST=stella
command -v "$TEST" >/dev/null 2>&1 || { echo "*** could not fine acme" >&2; exit 10; }
EMULATOR=$TEST

# use XM module specified on command line
if [ $# -eq 0 ]; then
	MODFILE=""
else 
	MODFILE="$1"
fi

# run xc2tiatune with specifed modfile and then assemble and emulate the binary file
"$XM2TIATUNE" "$MODFILE"
if [ "$?" = "0" ]
then
  "$ACME" main.asm
  if [ "$?" = "0" ]
  then 
    "$EMULATOR" test.bin
  fi
fi
