FROM ubuntu:latest

RUN apt update
RUN apt install -y wget libgtk2.0-0 libsoup2.4-1 libarchive13 libglu1 libgtk-3-0 libnss3 libasound2 libgconf-2-4 libcap2

RUN wget -O UnitySetup http://beta.unity3d.com/download/${UNITY_HASH}/UnitySetup-${UNITY_VERSION}
RUN chmod +x UnitySetup

RUN yes | ./UnitySetup -u -l Unity -d UnityDownload

RUN rm -f && rm -rf UnitySetup UnityDownload

CMD cd Unity/Editor
