#!/bin/sh

# stop if project exists
oc export project/openshift-unit >/dev/null 2>&1
if [ "$?" -eq "0" ]; then
  echo "project openshift-unit found; run make clean first"
	exit 1
fi
  
find openshift -name \*.yml -type f -exec oc create -f {} \;
