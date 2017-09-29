@ECHO OFF
	:: CONSTANTS
	:: DOCKER_APP nome del repository dell'immagine. Sostituire / con _
	SET "TAB=	"
	SET PRV_DOCKER_HUB=%1
	SET DOCKER_APP=%2
	SET DOCKER_APP_VER=%3
	SET PRG_PATH=
	REG Query "HKLM\Hardware\Description\System\CentralProcessor\0" | find /i "x86" > NUL && set OS_ARCH=32BIT || set OS_ARCH=64BIT
	
	IF "%OS_ARCH%"=="32BIT" (
		SET PRG_PATH=%PROGRAMFILES%
	) ELSE (
		SET PRG_PATH=%PROGRAMW6432%
	)

	:: MAIN
	CALL :GET_NOW_LOG "CHOCO - Verifica installazione"
	IF NOT EXIST C:\ProgramData\Chocolatey\ (
		CALL :GET_NOW_LOG "CHOCO - non presente"
		CALL :GET_NOW_LOG "CHOCO - Installazione"
		@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
	) ELSE (
		CALL :GET_NOW_LOG "CHOCO - gia' installato"
	)
	CALL %4.bat
GOTO :EOF

:GET_NOW_LOG
	batch_utils.cmd %*
GOTO :EOF