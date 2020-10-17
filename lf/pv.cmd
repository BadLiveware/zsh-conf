@echo off
setlocal

set _extension=%~x1

:showarchive
setlocal
CALL 7z.exe l -- %1
endlocal
IF %_extension%==.zip (
  CALL :showarchive %1 
  exit
)
IF %_extension%==.iso (
  CALL :showarchive %1
  exit
)
CALL bat.exe --style=plain,numbers,changes --wrap --line-range 0:%2 -- %1