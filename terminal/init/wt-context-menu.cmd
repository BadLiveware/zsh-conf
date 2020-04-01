REM Add to context menu
REG ADD "HKCR\Directory\Background\shell\wt" /ve /t REG_SZ /d "Open Windows Terminal here" /f

REM Add command
REG ADD "HKCR\Directory\Background\shell\wt\command" /ve /t REG_SZ /d "%USERPROFILE%\\AppData\\Local\\Microsoft\\WindowsApps\\wt.exe -d ." /f

REM Add icon
REG ADD "HKCR\Directory\Background\shell\wt" /v "Icon" /t REG_SZ /d "%USERPROFILE%/.config/terminal/resources/terminal.ico" /f

