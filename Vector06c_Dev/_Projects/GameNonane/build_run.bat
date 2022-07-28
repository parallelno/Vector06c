python tools/charGenerator.py
python tools/levelGenerator.py

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