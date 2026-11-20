@echo off
setlocal
cd /d "%~dp0"

rem Desert Gun ROM build - original Intel 8080 source, zmac v1.3; no Python.
if defined ZMAC (
    set "ZMAC_BIN=%ZMAC%"
) else if exist "tools\zmac.exe" (
    set "ZMAC_BIN=tools\zmac.exe"
) else (
    set "ZMAC_BIN=zmac"
)
where "%ZMAC_BIN%" >nul 2>&1
if errorlevel 1 if not exist "%ZMAC_BIN%" (
    echo ERROR: zmac v1.3 not found. Set ZMAC or use tools\zmac.exe.
    exit /b 1
)
if not exist "src\desertgun.asm" (
    echo ERROR: Missing src\desertgun.asm
    exit /b 1
)

echo Desert Gun ROM build
echo [1/4] Prepare output
if not exist "build" mkdir "build"
if not exist "roms" mkdir "roms"
del /q "build\desertgu.bin" "build\desertgu.lst" "roms\desertgu.zip" >nul 2>&1
for %%F in (9316.1h 9316.1g 9316.1f desertgu.e) do if exist "build\%%F" del /q "build\%%F"

echo [2/4] Assemble Intel 8080 source (zmac v1.3)
"%ZMAC_BIN%" -c -o "build\desertgu.bin" -x "build\desertgu.lst" "src\desertgun.asm"
if errorlevel 1 (
    echo ERROR: Assembly failed.
    exit /b 1
)
if not exist "build\desertgu.bin" (
    echo ERROR: No binary image produced.
    exit /b 1
)

echo [3/4] Split and verify four 2 KB ROMs
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "$ErrorActionPreference='Stop';" ^
    "$bytes=[IO.File]::ReadAllBytes('build\desertgu.bin');" ^
    "if($bytes.Length -ne 8192){throw 'Binary image must contain exactly 8192 bytes'};" ^
    "$names=@('9316.1h','9316.1g','9316.1f','desertgu.e');" ^
    "$sha=@('4d0a3a59d4f8181c6e30966a6b1d19ba5b29c398','8fb8e85844a8ec6c0722883013ecdd4eeaeb08c1','1cc4e9b0aa7e9546c133bd40d40ede6f2fbe93ba','202433dfb174901bd3b91e843d9d697a8333ef9e');" ^
    "for($i=0;$i -lt 4;$i++){ $part=[byte[]]::new(2048);[Array]::Copy($bytes,$i*2048,$part,0,2048);$file=Join-Path 'build' $names[$i];[IO.File]::WriteAllBytes($file,$part);$actual=(Get-FileHash $file -Algorithm SHA1).Hash.ToLowerInvariant();if($actual -ne $sha[$i]){throw ($names[$i]+' SHA1 mismatch: '+$actual)};Write-Host ($names[$i]+' OK '+$actual) }"
if errorlevel 1 (
    echo ERROR: ROM splitting or verification failed.
    exit /b 1
)

echo [4/4] Package roms\desertgu.zip
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "$ErrorActionPreference='Stop';" ^
    "Compress-Archive -LiteralPath @('build\9316.1h','build\9316.1g','build\9316.1f','build\desertgu.e') -DestinationPath 'roms\desertgu.zip' -Force"
if errorlevel 1 (
    echo ERROR: ZIP packaging failed.
    exit /b 1
)
if not exist "roms\desertgu.zip" (
    echo ERROR: ROM ZIP was not created.
    exit /b 1
)
echo Build complete: roms\desertgu.zip
exit /b 0
