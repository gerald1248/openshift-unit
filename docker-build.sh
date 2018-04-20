#!/bin/sh

OPENSHIFT_UNIT_VERSION=latest
SHUNIT2_VERSION=latest
OC_VERSION=latest
DOWNLOAD_ALWAYS=0

for DEPENDENCY in jq curl head tail unzip; do
  if [ -z $(which $DEPENDENCY) ]; then
    echo "Missing dependency - '$DEPENDENCY' required"
    exit 1
  fi
done

if [ ! -d downloads/ ]; then
  mkdir downloads
fi

if [ ! -f downloads/shunit2 ] || [ $DOWNLOAD_ALWAYS -gt 0 ]; then
  SHUNIT2_URL=`curl -s https://api.github.com/repos/kward/shunit2/releases/$SHUNIT2_VERSION | jq -cr '.zipball_url'`
  if [ -z $SHUNIT2_URL ]; then
    echo "Can't determine shunit2 download URL"
    exit 1
  fi
  echo "Downloading $SHUNIT2_URL"
  curl -sL $SHUNIT2_URL -o downloads/shunit2.zip && unzip -o downloads/shunit2.zip -d downloads && cp downloads/kward-shunit2*/shunit2 downloads/
fi

if [ ! -f downloads/oc ] || [ $DOWNLOAD_ALWAYS -gt 0 ]; then
  OC_URL=`curl -s https://api.github.com/repos/openshift/origin/releases/latest | jq -cr '.assets[] | select( .name | contains(".tar.gz"))' | head -n1 | jq -rc '.browser_download_url'`
  if [ -z $OC_URL ]; then
    echo "Can't determine oc download URL"
    exit 1
  fi
  echo "Downloading $OC_URL"
  curl -L $OC_URL -o downloads/oc.tar.gz && tar -xf downloads/oc.tar.gz -C downloads/ && cp downloads/openshift-origin-client-tools-*/oc downloads/
fi

docker build -t openshift-unit:$OPENSHIFT_UNIT_VERSION .
