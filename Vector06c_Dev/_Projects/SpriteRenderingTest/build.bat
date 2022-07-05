@echo off
set dirname=%cd%
For %%A in ("%dirname%") do (
    Set projectName=%%~nxA
)

del *.hex *.lst *.obj *.rom *.bin

@echo on
..\..\retroassembler\retroassembler.exe -C=8080 main.8080.asm %projectName%
ren %projectName%.bin %projectName%.rom
@echo off

..\..\Emu80\Emu80qt.exe %projectName%.rom