# CYCLIGENT docker container
--------------------------------
### Container Docker con GUI per CYCLIGENT, un'interfaccia grafica per GIT
Container sviluppato con l'obbiettivo di unificare l'ambiente di sviluppo di tutti i programmatori Gamba Bruno S.p.A.
Per creare il container utilizzare il seguente comando:
- Windows:
`docker run -tdi --name=cycligent --net="host" --privileged=true -e DISPLAY=%COMPUTERNAME%:0.0 -v intellij-idea_workdir:/home/developer ryther/cycligent:latest`
- Linux:
`sudo docker run -tdi --name=cycligent --net="host" --privileged=true -e DISPLAY=$DISPLAY -v intellij-idea_workdir:/home/developer -v /tmp/.X11-unix:/tmp/.X11-unix ryther/cycligent:latest`
---------------------------------
Una volta creato il container, per eseguirlo nuovamente utilizzare il comando:  
`docker start cycligent`
