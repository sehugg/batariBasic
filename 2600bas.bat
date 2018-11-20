@echo off
if X%bB% == X goto nobb
if exist sed.exe goto havesed
if exist %bB%/sed.exe goto havesed
goto nosed
:havesed
preprocess <%1 | 2600basic.exe -i %bB%>bB.asm
if errorlevel 1 goto bBerror
if X%2 == X-O goto optimize
postprocess -i %bB%>%1.asm
goto nooptimize
:optimize
postprocess -i %bB%| optimize >%1.asm
:nooptimize
dasm %1.asm -I%bB%/includes -f3 -o%1.bin | sed "/Label mismatch/d" | sed "/shakescreen/d;/rand16/d;/debugscore/d;/pfscore/d;/noscore/d;/vblank_bB_code/d;/PFcolorandheight/d;/pfrowheight/d;/pfres/d;/PFmaskvalue/d;/overscan_time/d;/vblank_time/d;/no_blank_lines/d;/superchip/d;/ROM2k/d;/NO_ILLEGAL_OPCODES/d;/minikernel/d;/debugcycles/d;/mincycles/d;/legacy/d;/PFcolors/d;/playercolors/d;/player1colors/d;/backgroundchange/d;/readpaddle/d;/multisprite/d;/PFheights/d;/bankswitch/d;/Unresolved Symbols/d" | sed "2,/-->/!{ /-->/,/-->/d; }" | sed "s/--> 0./Possible duplicate label: /"
rem yes, I know :) This is the first attempt to make DASM's output more useful!

goto end


:nosed
echo sed.exe not found.  Continuing without it.
pause
preprocess <%1 | 2600basic.exe -i %bB%>bB.asm
if errorlevel 1 goto bBerror
if X%2 == X-O goto optimize2
postprocess -i %bB%>%1.asm
goto nooptimize2
:optimize2
postprocess -i %bB%| optimize >%1.asm
:nooptimize2
dasm %1.asm -I%bB%/includes -f3 -o%1.bin
goto end

:nobb
echo bB environment variable not set.

:bBerror
echo Compilation failed.


:end
