@ECHO OFF
	SET DKR_CMD=docker run -tdi --name=cycligent --net="host" --privileged=true -e DISPLAY=%COMPUTERNAME%:0.0 -v intellij-idea_workdir:/home/developer ryther/cycligent:lates
GOTO :EOF