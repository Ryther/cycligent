@echo off
	CALL :%*
	ECHO Questo e' un file libreria e non va eseguito singolarmente
	ECHO ma utilizzato in altri batch per richiamare le sue funioni
	EXIT /b %ERRORLEVEL%
GOTO :EOF

:GET_NOW_LOG
	FOR /F "usebackq tokens=1,2 delims==" %%i in (`wmic os get LocalDateTime /VALUE 2^>NUL`) do if '.%%i.'=='.LocalDateTime.' set ldt=%%j
	SET ldt=%ldt:~0,4%-%ldt:~4,2%-%ldt:~6,2% %ldt:~8,2%:%ldt:~10,2%:%ldt:~12,6%
	ECHO [%ldt%] - %~1
	ECHO [%ldt%] - %~1 >> %DOCKER_APP%.log
	:END
GOTO :EOF