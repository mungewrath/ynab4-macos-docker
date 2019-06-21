FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive

# Install base packages
RUN apt-get update && apt-get install -y --no-install-recommends software-properties-common gnupg2 sudo

# Setup i386 architecture
RUN dpkg --add-architecture i386; \
    echo 'deb http://ppa.launchpad.net/ubuntu-wine/ppa/ubuntu vivid main' >>  /etc/apt/sources.list; \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 5A9A06AEF9CB8DB0

# Install WINE
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv F987672F
RUN apt-add-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ bionic main'; \
    apt-get update; \
    apt-get install -y --install-recommends winehq-stable winetricks

# Set timezone to PST
ENV TZ=America/Los_Angeles
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Create user
RUN export uid=1000 gid=1000 && \
    mkdir -p /home/docker && \
    echo "docker:x:${uid}:${gid}:Docker,,,:/home/docker:/bin/bash" >> /etc/passwd && \
    echo "docker:x:${uid}:" >> /etc/group && \
    echo "docker ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/docker && \
    chmod 0440 /etc/sudoers.d/docker && \
    chown ${uid}:${gid} -R /home/docker
ENV HOME /home/docker
WORKDIR /home/docker
USER docker
# Add the ynab installer to the image.
ADD ["https://downloadpull-youneedabudgetco.netdna-ssl.com/ynab4/liveCaptive/Win/YNAB%204_4.3.857_Setup.exe", "ynab_setup.exe"]

ENTRYPOINT ["/bin/bash", "-c"]
CMD ["wine ./ynab_setup.exe | cat;"]

