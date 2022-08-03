python tools/charGenerator.py -i sources/hero.json -o chars/hero.dasm
python tools/charGenerator.py -i sources/skeleton.json -o chars/skeleton.dasm
python tools/levelGenerator.py -i sources/level01.json -o levels/level01.dasm

@echo off

set dirname=%cd%
For %%A in ("%dirname%") do (
    Set projectName=%%~nxA
)

del *.hex *.lst *.obj *.rom

@echo on
..\..\retroassembler\retroassembler.exe -C=8080 main.asm %projectName%
@echo off
ren %projectName%.bin %projectName%.rom


if exist %projectName%.rom ..\..\Emu80\Emu80qt.exe %projectName%.rom