@echo off
set dirname=%cd%
For %%A in ("%dirname%") do (
    Set projectName=%%~nxA
)

set TASMTABS=..\..\Tasm32\

del *.hex *.lst *.obj *.rom

@echo on
..\..\Tasm32\tasm.exe -85 -b zx2.asm %projectName%.rom
@echo off