#!/bin/sh

# updating requires deletion - can't create --from-file with same name
oc delete -n openshift-unit --ignore-not-found=true configmap/openshift-unit
oc create -n openshift-unit configmap openshift-unit --from-file=test/
