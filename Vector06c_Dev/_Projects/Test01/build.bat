@echo off
set dirname=%cd%
For %%A in ("%dirname%") do (
    Set projectName=%%~nxA
)

set TASMTABS=..\..\Tasm32\

del *.hex *.lst *.obj *.rom

@echo on
..\..\Tasm32\tasm.exe -85 -i -b main.asm
@echo off

ren main.obj %projectName%.rom

..\..\Emu80\Emu80qt.exe %projectName%.rom