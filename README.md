# Unity in Docker

[![Build Status](https://travis-ci.org/StaNov/unity-docker.svg?branch=master)](https://travis-ci.org/StaNov/unity-docker)

## What it does

Provides Unity in Docker image.

Useful for continuous integration jobs.


    docker pull -t unityImage stanov/unity:2020.1.10f1
    
    docker run unityImage unity -runTests -testPlatform editmode
    docker run unityImage unity -runTests -testPlatform playmode
    
_Note: The activation script assumes that you don't use Unity for commercial purposes. If it is not true, don't use this image._

## What it does in more detail

* Downloads and installs Unity in Ubuntu image.
* Pushes the image to Docker Hub as `stanov/unity:{version}-no-license`.
* Activates the image by a free license.
* Pushes activated image to Docker Hub as `stanov/unity:{version}`.

## How to add a new version

* Fork the repo.
* Modify your Docker Hub credentials.
* Modify the version variable.
* Configure Travis CI
  * Add your Unity credentials to Travis CI variables (`UNITY_EMAIL` and `UNITY_PASSWORD`)
    * Separate Unity account is preferred.
  * Enable Unity TFA and add recovery code to the `UNITY_RECOVERY_CODE` Travis variable.
* Run in Travis CI.
* Pull image from your Docker Hub repo.
