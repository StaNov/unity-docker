set -e

UNITY_VERSION=$1

sudo apt-get install libxml2-utils -y
# docker build -t unity --build-arg UNITY_VERSION=$UNITY_VERSION --build-arg UNITY_HASH=$UNITY_HASH .
docker pull stanov/unity:${UNITY_VERSION}-no-license  # TODO remove
docker tag stanov/unity:${UNITY_VERSION}-no-license unity  # TODO remove
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
pip3 install -r activation/requirements.txt
while [[ "$(curl -s -o /dev/null -w ''%{http_code}'' localhost:4444)" != "200" ]]; do sleep 1; done
python3 activation/activate.py
docker exec remoteSelenium bash -c 'sudo cp /home/seluser/Downloads/* /licenseFile'
docker kill remoteSelenium
sudo mv licenseFile/*.ulf licenseFile/UnityLicense.ulf
ls licenseFile
cat licenseFile/*.ulf
