FROM ubuntu:latest

RUN apt-get update
RUN apt-get install -y wget sudo libgtk2.0-0 libx11-xcb-dev \
    libxtst6 libxss1 libgconf-2-4 libnss3 libasound2

ENV HOME /home/developer

RUN useradd --create-home --home-dir $HOME developer \
        && chown -R developer:developer $HOME

RUN export uid=1000 gid=1000 && \
    mkdir -p /home/developer && \
    echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:${uid}:" >> /etc/group && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown ${uid}:${gid} -R /home/developer

USER developer

RUN sudo wget https://public-cdn.cloud.unity3d.com/hub/prod/UnityHub.AppImage && \
    sudo chmod +x UnityHub.AppImage && \
    sudo ./UnityHub.AppImage --appimage-extract && \
    sudo chmod 777 squashfs-root

CMD sudo ./squashfs-root/unityhub
