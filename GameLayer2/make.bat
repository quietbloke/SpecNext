echo off
..\..\..\tools\sjasmplus .\Main.asm
if ERRORLEVEL 1 goto doexit
copy *.bin .\bin\*.* >nul 2>&1
copy *.nxb .\bin\*.* >nul 2>&1
copy *.spr .\bin\*.* >nul 2>&1
copy *.sna .\bin\*.* >nul 2>&1
:doexit