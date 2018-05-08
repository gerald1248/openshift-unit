#!/bin/sh

# fetch OPENSHIFT_UNIT_NAME and OPENSHIFT_UNIT_NAMESPACE
. ./exports

# stop if project not available
oc export project/${OPENSHIFT_UNIT_NAMESPACE} >/dev/null 2>&1
if [ ! "$?" -eq "0" ]; then
  echo "project ${OPENSHIFT_UNIT_NAMESPACE} not found; run make create first"
  exit 1
fi

# updating requires deletion - can't create --from-file with same name
oc delete -n ${OPENSHIFT_UNIT_NAMESPACE} --ignore-not-found=true configmap/${OPENSHIFT_UNIT_NAME}
oc create -n ${OPENSHIFT_UNIT_NAMESPACE} configmap ${OPENSHIFT_UNIT_NAME} --from-file=test/
