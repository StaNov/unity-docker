FROM ubuntu:latest

RUN apt update
RUN apt install -y wget libgtk2.0-0 libsoup2.4-1 libarchive13 libglu1 libgtk-3-0 libnss3 libasound2 libgconf-2-4 libcap2

RUN wget http://beta.unity3d.com/download/292b93d75a2c/UnitySetup-2019.1.0f2
RUN chmod +x UnitySetup-2019.1.0f2

RUN yes | ./UnitySetup-2019.1.0f2 -u -l Unity -d unitydownload

RUN rm -rf unitydownload

CMD cd Unity/Editor
