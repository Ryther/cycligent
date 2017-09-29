@ECHO OFF
	SETLOCAL EnableDelayedExpansion
	CALL docker_command.cmd
	CALL :GET_NOW_LOG "VcXsrv - Verifica installazione"
	CHOCO list -l -r vcxsrv > %TEMP%\tmp_vcxsrv_check.txt
	SET vcxsrv=
	SET /p vcxsrv=<%TEMP%\tmp_vcxsrv_check.txt
	verify >nul
	IF "%vcxsrv%"=="" (
		CALL :GET_NOW_LOG "VcXsrv - Installazione"
		CHOCO install -y vcxsrv
	)	ELSE (
		CALL :GET_NOW_LOG "VcXsrv - gia' presente"
	)
	CALL :GET_NOW_LOG "VcXsrv - in esecuzione?"
	TASKLIST /FI "IMAGENAME eq vcxsrv.exe" 2>NUL | FIND /I /N "vcxsrv.exe">NUL
	IF "%ERRORLEVEL%"=="0" (
		CALL :GET_NOW_LOG "VcXsrv - gia' avviato"
	) ELSE (
		CALL :GET_NOW_LOG "VcXsrv - avvio in corso"
		START "VcXsrv" "%PRG_PATH%\VcXsrv\vcxsrv.exe" :0 -ac -terminate -lesspointer -multiwindow -clipboard -wgl
	)
	
	CALL :GET_NOW_LOG "Docker - Verifica installazione"
	CHOCO list -l -r vcxsrv > %TEMP%\tmp_docker_check.txt
	SET docker=
	SET /p docker=<%TEMP%\tmp_docker_check.txt
	IF "%docker%"=="" (
		CALL :GET_NOW_LOG "Docker - Installazione"
		CHOCO install -y docker-for-windows
	)	ELSE (
		CALL :GET_NOW_LOG "Docker - gia' presente"
	)
	CALL :GET_NOW_LOG "Docker - in esecuzione?"
	TASKLIST /FI "IMAGENAME eq Docker*" 2>NUL | FIND /I /N "Docker">NUL
	IF "%ERRORLEVEL%"=="0" (
		CALL :GET_NOW_LOG "Docker - gia' avviato"
		
	) ELSE (
		CALL :GET_NOW_LOG "Docker - avvio in corso"
::START "Docker" "%PRG_PATH%\Docker\Docker\Docker for Windows.exe"
		SET try=0
		SET tries=3
		ECHO !try! !tries!
		CALL :DKR_ISRUNNING !try! !tries!
	)
	
	CALL :GET_NOW_LOG "%DOCKER_APP% - Verifica esistenza immagine"
	SET img_var=%PRV_DOCKER_HUB%/%DOCKER_APP:_=/%
	DOCKER images --format "{{.Repository}}" --filter "reference=%img_var%:latest" > %TEMP%\%DOCKER_APP%.txt
	SET docker_image=
	SET /p docker_image=<%TEMP%\%DOCKER_APP%.txt
	verify >nul
	IF "%docker_image%"=="" (
		CALL :GET_NOW_LOG "%DOCKER_APP% - Immagine non presente"
		CALL :GET_NOW_LOG "%DOCKER_APP% - Scaricamento immagine"
		DOCKER pull %img_var%:latest
		IF "%ERRORLEVEL%"=="0" (
			CALL :GET_NOW_LOG "%DOCKER_APP% - Immagine ottenuta con successo"
		) ELSE (
			CALL :GET_NOW_LOG "%DOCKER_APP% - Immagine %PRV_DOCKER_HUB%/%DOCKER_APP%:latest non trovata."
			CALL :GET_NOW_LOG "%DOCKER_APP% - Assicurarsi che il file sia presente nella stessa cartella"
			CALL :GET_NOW_LOG "%DOCKER_APP% - da cui e' stato eseguito questo script."
			CALL :GET_NOW_LOG "%DOCKER_APP% - Script terminato con errore:"
			CALL :GET_NOW_LOG "%TAB%Immagine %img_var%:latest non trovata o non caricata"
			PAUSE
			GOTO :EOF
		)
	)
	
	CALL :GET_NOW_LOG "%DOCKER_APP% - Verifica esistenza container"
	DOCKER ps -a --format "{{.Names}}" --filter "name=%DOCKER_APP%" > %TEMP%\%DOCKER_APP%.txt
	SET docker_container=
	SET /p docker_container=<%TEMP%\%DOCKER_APP%.txt
	verify >nul
	IF "%docker_container%" == "" (
		CALL :GET_NOW_LOG "%DOCKER_APP% - Creazione container"
		%DKR_CMD%
	)	ELSE (
		CALL :GET_NOW_LOG "%DOCKER_APP% - container gia' esistente"
		CALL :GET_NOW_LOG "%DOCKER_APP% - container gia' avviato?"
		DOCKER ps --format "{{.Names}}" --filter "name=%DOCKER_APP%" > %TEMP%\%DOCKER_APP%.txt
		SET docker_container_s=
		SET /p docker_container_s=<%TEMP%\%DOCKER_APP%.txt
		verify >nul
		IF "%docker_container_s%"=="" (
			CALL :GET_NOW_LOG "%DOCKER_APP% - Container non avviato"
			CALL :GET_NOW_LOG "%DOCKER_APP% - Avvio container"
			DOCKER start %DOCKER_APP%
		) ELSE (
			CALL :GET_NOW_LOG "%DOCKER_APP% - Container gia' in esecuzione"
		)
	)
GOTO :EOF

:DKR_ISRUNNING
	PAUSE
	SET try2=%1
	ECHO %try2%
	PAUSE
	IF "%1"=="%2" (
		CALL :GET_NOW_LOG "Docker - impossibile avviare docker"
		PAUSE
		GOTO :EOF
	) ELSE (
		CALL :GET_NOW_LOG "Docker - Tentativo attesa avvio: !try2!/%2"
		DOCKER ps >NUL 2>&1
		SET /A "test=%ERRORLEVEL%"
		IF %test% GTR 0 (
			PING localhost -n 4 >NUL 2>&1
			SET /A "try2+=1"
			ECHO !try2!
			CALL :DKR_ISRUNNING !try2! %2
		) ELSE (
			CALL :GET_NOW_LOG "Docker - Avviato correttamente"
			GOTO :EOF
		))
	:END
GOTO :EOF

:GET_NOW_LOG
	batch_utils.cmd %*
GOTO :EOF