#!/bin/sh

# fetch OPENSHIFT_UNIT_NAME and OPENSHIFT_UNIT_NAMESPACE
. exports

# updating requires deletion - can't create --from-file with same name
oc delete -n ${OPENSHIFT_UNIT_NAMESPACE} --ignore-not-found=true configmap/${OPENSHIFT_UNIT_NAME}
oc create -n ${OPENSHIFT_UNIT_NAMESPACE} configmap ${OPENSHIFT_UNIT_NAME} --from-file=test/
