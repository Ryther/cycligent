FROM phusion/baseimage:latest

LABEL maintainer="edoardo.zanoni@gambabruno.it"

# Variabili della build
ENV	LANG=C.UTF-8 \
	CYCLIGENT_VER=0.5.2

# Aggiornamento ed installazione delle applicazioni di base
RUN sed 's/main$/main universe/' -i /etc/apt/sources.list && \
    apt-get update -qq && \
    echo 'Installing OS dependencies' && \
    apt-get install -qq -y --fix-missing sudo \
		software-properties-common \
		libxext-dev \
		libxrender-dev \
		libxslt1.1 \
		libxtst-dev \
		libgtk2.0-0 \
		libcanberra-gtk-module \
		libsecret-1-0 \
		git \
		gnome-keyring \
		unzip \
		wget
    echo 'Cleaning up' && \
    apt-get clean -qq -y && \
    apt-get autoclean -qq -y && \
    apt-get autoremove -qq -y &&  \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

# Creazione utente principale (developer)
RUN echo 'Creating user: developer' && \
    mkdir -p /home/developer && \
    echo "developer:x:1000:1000:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:1000:" >> /etc/group && \
    sudo echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    sudo chmod 0440 /etc/sudoers.d/developer && \
    sudo chown developer:developer -R /home/developer && \
    sudo chown root:root /usr/bin/sudo && \
    chmod 4755 /usr/bin/sudo

# Download ed installazione di Cycligent
RUN echo 'Downloading Cycligent ${CYCLIGENT_VER}' && \
    wget https://s3-us-west-2.amazonaws.com/cycligent-downloads/CycligentGitTool/installers/linux/x64/CycligentGitTool-${CYCLIGENT_VER}-linux-x64.deb -O /tmp/cycligent-${CYCLIGENT_VER}.deb -q && \
    echo 'Installing Cyclignet ${CYCLIGENT_VER}' && \
	sudo dpkg -i /tmp/cycligent-${CYCLIGENT_VER}.deb \
    rm /tmp/cycligent-${CYCLIGENT_VER}.deb

# Creazione dei mounting point
VOLUME [ "/home/developer" ]

# Operazioni finali
USER developer
ENV HOME /home/developer
WORKDIR /home/developer
# ENTRYPOINT [ "/opt/intellij/bin/idea.sh" ]