FROM ubuntu:latest

RUN apt update
RUN apt install -y wget libgtk2.0-0 libsoup2.4-1 libarchive13

RUN wget http://beta.unity3d.com/download/292b93d75a2c/UnitySetup-2019.1.0f2
RUN chmod +x UnitySetup-2019.1.0f2

RUN yes | ./UnitySetup-2019.1.0f2 -u -l unityinstall -d unitydownload

CMD cd unityinstall/Editor
