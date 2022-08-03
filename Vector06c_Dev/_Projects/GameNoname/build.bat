python tools/charGenerator.py -i "sources/hero.json" -o "chars/hero.dasm"
python tools/levelGenerator.py

@echo off

set dirname=%cd%
For %%A in ("%dirname%") do (
    Set projectName=%%~nxA
)

del *.hex *.lst *.obj *.rom

@echo on
..\..\retroassembler\retroassembler.exe -C=8080 main.asm %projectName%
ren %projectName%.bin %projectName%.rom
@echo off