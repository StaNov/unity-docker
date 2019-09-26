FROM ubuntu:latest

RUN apt update
RUN apt install -y wget
#RUN apt install -y libgconf-2-4
RUN apt install -y libgtk2.0-0
RUN apt install -y libsoup2.4-1
RUN apt install -y libarchive13

RUN wget http://beta.unity3d.com/download/292b93d75a2c/UnitySetup-2019.1.0f2
RUN chmod +x UnitySetup-2019.1.0f2

RUN yes | ./UnitySetup-2019.1.0f2 -u -l unityinstall -d unitydownload-f
