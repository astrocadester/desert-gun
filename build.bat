@echo off
setlocal
cd /d "%~dp0"
if not exist "src\desertgun.asm" (
  echo RE incomplete: src\desertgun.asm has not yet been recovered from the original ROM. 1>&2
  exit /b 2
)
if not exist build mkdir build
tools\zmac.exe --zmac -o "build\desertgun.bin" "src\desertgun.asm"
if errorlevel 1 exit /b 1
echo Assembled build\desertgun.bin; chip-by-chip ROM identity is not yet verified.
