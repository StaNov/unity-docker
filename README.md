# Unity in Docker

## What it does

Provides Unity in Docker image

Useful for continuous integration jobs.


    docker pull -t unityImage stanov/unity:2020.1.10f1
    
    docker run unityImage unity -runTests -testPlatform editmode
    docker run unityImage unity -runTests -testPlatform playmode

## What it does in more detail

* Downloads and installs Unity in Ubuntu image.
* Pushes the image to Docker Hub as `stanov/unity:{version}-no-license`.
* Activates the image by a free license.
* Pushes activated image to Docker Hub as `stanov/unity:{version}`.

## How to add a new version

* Fork the repo.
* Modify your Docker Hub credentials.
* Modify the version variable.
* Run in Travis CI.
* Pull image from your Docker Hub repo.
