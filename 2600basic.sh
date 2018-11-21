#!/bin/bash
echo "Starting build of $1"

#z26="/Path/To/z26"
#Stella="/Path/To/Stella"
bB=.
BBPATH=./source
#VG="valgrind --track-origins=yes"
VG=""

[ -f ~/.profile ] && source ~/.profile

$VG $BBPATH/preprocess < "$1" | $VG $BBPATH/2600basic -i "$bB" > bB.asm
if [ "$?" -ne "0" ]
 then
  echo "Compilation failed."
  exit 1
fi
if [ "$2" = "-O" ]
  then
   $VG $BBPATH/postprocess -i "$bB" | $VG $BBPATH/optimize > "$1.asm"
  else
   $VG $BBPATH/postprocess -i "$bB" > "$1.asm"
fi
dasm "$1.asm" -I"$bB/includes" -f3 -l"$1.lst" -o"$1.bin" | sed '/Label mismatch/d' \
| sed '/shakescreen/d;/rand16/d;/debugscore/d;/pfscore/d;/noscore/d;/vblank_bB_code/d;/PFcolorandheight/d;/pfrowheight/d;/pfres/d;/PFmaskvalue/d;/overscan_time/d;/vblank_time/d;/no_blank_lines/d;/superchip/d;/ROM2k/d;/NO_ILLEGAL_OPCODES/d;/minikernel/d;/debugcycles/d;/mincycles/d;/legacy/d;/PFcolors/d;/playercolors/d;/player1colors/d;/backgroundchange/d;/readpaddle/d;/multisprite/d;/PFheights/d;/bankswitch/d;/Unresolved Symbols/d' \
| sed '2,/-->/!{ /-->/,/-->/d; }' \
| sed 's/--> 0./Possible duplicate label: /'

if [ "$?" -ne "0" ]
 then
  echo "Assembly failed."
  exit 2
fi

echo "Build complete."

[ -f "$z26" ] && "$z26" "$1.bin"
[ -f "$Stella" ] && "$Stella" "$1.bin"

exit 0

