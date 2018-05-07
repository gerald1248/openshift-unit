#!/bin/sh

# fetch OPENSHIFT_UNIT_NAMESPACE and OPENSHIFT_UNIT_NAME first
. exports

oc delete --ignore-not-found project/${OPENSHIFT_UNIT_NAMESPACE}
oc delete --ignore-not-found clusterrolebinding/${OPENSHIFT_UNIT_NAME}
