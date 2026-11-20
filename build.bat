@echo off
setlocal
cd /d "%~dp0"
if not exist "build" mkdir "build"
if not exist "roms" mkdir "roms"
if not exist "docs" mkdir "docs"
py -3 tools\audit_words.py
if errorlevel 1 exit /b 1
py -3 tools\recover_8080.py desertgun
if errorlevel 1 exit /b 1
py -3 tools\interpreter_lineage.py
if errorlevel 1 exit /b 1
py -3 tools\memory_map.py
if errorlevel 1 exit /b 1
tools\zmac.exe -c -o build\desertgu.bin -x build\desertgu.lst src\desertgun.asm
if errorlevel 1 exit /b 1
py -3 tools\verify_rom.py
if errorlevel 1 exit /b 1
