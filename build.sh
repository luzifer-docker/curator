#!/bin/bash
set -euo pipefail

HOST_OS=$(uname -s)

### ---- ###

echo "Switch back to master"
git checkout master
git reset --hard origin/master

### ---- ###

if ! [ -e jq ]; then
  echo "Loading local copy of jq-1.5"

  case ${HOST_OS} in
    Linux)
      curl -sSLo ./jq https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64
      ;;
    Darwin)
      curl -sSLo ./jq https://github.com/stedolan/jq/releases/download/jq-1.5/jq-osx-amd64
      ;;
    *)
      echo "/!\\ Unable to download jq for ${HOST_OS}"
      exit 1
      ;;
  esac

  chmod +x jq
fi

### ---- ###

echo "Fetching latest version number of awscli"

CURATOR_VERSION=$(curl -sSL https://pypi.python.org/pypi/elasticsearch-curator/json | ./jq -r .info.version)

if ( git tag -l ${CURATOR_VERSION} | grep -q ${CURATOR_VERSION} ); then
  echo "/!\\ Already got a tag for version ${CURATOR_VERSION}, stopping now"
  exit 0
fi

echo "Writing requirements.txt"
echo "elasticsearch-curator==${CURATOR_VERSION}" > requirements.txt
echo "PyYAML==3.13" >>requirements.txt # Temp. fix for https://github.com/elastic/curator/issues/1368

### ---- ###

echo "Testing build..."
docker build .

### ---- ###

echo "Updating repository..."
git add requirements.txt
git -c user.name='Travis Automated Update' -c user.email='travis@luzifer.io' \
  commit -m "elasticsearch-curator ${CURATOR_VERSION}"
git tag ${CURATOR_VERSION}

git push -q https://auth:${GH_TOKEN}@github.com/luzifer-docker/curator master --tags
