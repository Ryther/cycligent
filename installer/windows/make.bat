@ECHO OFF
	IF EXIST output (
		RMDIR /S /Q output
	)
	CD files
	7Z a files ^
		batch_utils.cmd ^
		cycligent_exec.bat ^
		docker_command.cmd ^
		starter.bat
	MKDIR ..\output
	COPY /b 7zSD.sfx + config.txt + files.7z ..\output\cycligent.exe
	DEL files.7z