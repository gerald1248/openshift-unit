#!/bin/sh

# export OPENSHIFT_UNIT_NAME and OPENSHIFT_UNIT_NAMESPACE
. ./exports

# stop if project exists
oc export project/${OPENSHIFT_UNIT_NAMESPACE} >/dev/null 2>&1
if [ "$?" -eq "0" ]; then
  echo "project ${OPENSHIFT_UNIT_NAMESPACE} found; run make clean first"
	exit 1
fi

oc new-project ${OPENSHIFT_UNIT_NAMESPACE} --display-name="OpenShift cluster tests" >/dev/null 2>&1
oc new-app --file=openshift/template.yml --param='NAME'="${OPENSHIFT_UNIT_NAME}" --param='NAMESPACE'="${OPENSHIFT_UNIT_NAMESPACE}"
