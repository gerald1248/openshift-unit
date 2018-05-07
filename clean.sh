#!/bin/sh
oc delete --ignore-not-found project/${OPENSHIFT_UNIT_NAMESPACE}
oc delete --ignore-not-found clusterrolebinding/${OPENSHIFT_UNIT_NAME}
