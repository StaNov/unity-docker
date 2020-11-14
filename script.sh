set -e

if [ -z "$UNITY_VERSION" ]; then
  echo "ERROR: UNITY_VERSION variable is not set."
  exit 1
fi

if [ -z "$UNITY_HASH" ]; then
  echo "ERROR: UNITY_HASH variable is not set."
  exit 1
fi

if [ -z "$UNITY_EMAIL" ]; then
  echo "ERROR: UNITY_EMAIL variable is not set."
  exit 1
fi

if [ -z "$UNITY_PASSWORD" ]; then
  echo "ERROR: UNITY_PASSWORD variable is not set."
  exit 1
fi

if [ -z "$UNITY_RECOVERY_CODE" ]; then
  echo "ERROR: UNITY_RECOVERY_CODE variable is not set."
  exit 1
fi

sudo apt-get install libxml2-utils -y -q

docker build -t unity --build-arg UNITY_VERSION=$UNITY_VERSION --build-arg UNITY_HASH=$UNITY_HASH .
# for debugging purposes to speed up the build, use those lines instead of the above one:
# docker pull stanov/unity:${UNITY_VERSION}-no-license
# docker tag stanov/unity:${UNITY_VERSION}-no-license unity

docker run --rm -v $(pwd)/licenseFile:/licenseFile -w /licenseFile unity unity -createManualActivationFile || echo "Unity returns code 1 even if it succeeds"
sudo xmllint --format --output licenseFile/UnityRequestFile.alf licenseFile/Unity_v${UNITY_VERSION}.alf
if [ -n "$DOCKER_HUB_PASSWORD" ]; then
  echo $DOCKER_HUB_PASSWORD | docker login --username stanov --password-stdin
  docker tag unity stanov/unity:${UNITY_VERSION}-no-license
  docker push stanov/unity:${UNITY_VERSION}-no-license
fi
echo "You can use the XML below to activate Unity with your license at https://license.unity3d.com/manual."
echo -e "\n\n\n" && cat licenseFile/UnityRequestFile.alf
cp licenseFile/UnityRequestFile.alf activation
docker run -d --rm --name remoteSelenium -p 4444:4444 -v /dev/shm:/dev/shm -v $(pwd)/licenseFile:/licenseFile selenium/standalone-chrome
pip3 install -q -r activation/requirements.txt
while [[ "$(curl -s -o /dev/null -w ''%{http_code}'' localhost:4444)" != "200" ]]; do sleep 1; done
echo "Running activation. Logs will appear when done."
python3 activation/activate.py selenium
echo "Activation done, license file downloaded."
docker exec remoteSelenium bash -c 'sudo cp /home/seluser/Downloads/* /licenseFile'
docker kill remoteSelenium
sudo mv licenseFile/*.ulf licenseFile/UnityLicense.ulf

docker build --build-arg UNITY_VERSION=$UNITY_VERSION -t stanov/unity:$UNITY_VERSION -f Dockerfile.license-add .
if [ -n "$DOCKER_HUB_PASSWORD" ]; then
  docker push stanov/unity:$UNITY_VERSION
fi
