FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive
ENV TZ=America/Los_Angeles

# Add i386 architecture and install dependencies
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    software-properties-common gnupg2 sudo curl && \
    mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://dl.winehq.org/wine-builds/winehq.key | gpg --dearmor > /etc/apt/keyrings/winehq.gpg && \
    chmod 644 /etc/apt/keyrings/winehq.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/winehq.gpg] https://dl.winehq.org/wine-builds/ubuntu/ focal main" > /etc/apt/sources.list.d/winehq.list && \
    apt-get update && \
    echo '#!/bin/sh\nexit 0' > /usr/sbin/policy-rc.d && \
    mkdir -p /var/run/dbus && \
    apt-get install -y --install-recommends winehq-stable winetricks

# Set timezone
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Create a non-root user
RUN export uid=1000 gid=1000 && \
    mkdir -p /home/docker && \
    echo "docker:x:${uid}:${gid}:Docker,,,:/home/docker:/bin/bash" >> /etc/passwd && \
    echo "docker:x:${uid}:" >> /etc/group && \
    echo "docker ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/docker && \
    chmod 0440 /etc/sudoers.d/docker && \
    chown ${uid}:${gid} -R /home/docker
ENV HOME /home/docker
WORKDIR /home/docker

# Add YNAB installer
COPY YNAB_4_4.3.857_Setup.exe ynab_setup.exe
RUN chown docker:docker ynab_setup.exe
USER docker

# Default command, use wine to run the YNAB installer
ENTRYPOINT ["/bin/bash", "-c"]
# Comment this line after the first installation
CMD ["wine ./ynab_setup.exe /DIR=Z:\\\\home\\\\docker\\\\YNAB && cat;"]
# Un-comment this line after the installation completes
# CMD ["wine Z:\\\\home\\\\docker\\\\YNAB\\\\YNAB\\ 4.exe"]