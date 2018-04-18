#!/bin/sh

# updating requires deletion - can't create --from-file with same name
configmap_file=`find . -name \*configmap-openshift-unit.yml | head -n1`
oc delete --ignore-not-found=true configmap/openshift-unit
oc create configmap openshift-unit --from-file=test/
oc export configmap/openshift-unit >${configmap_file}
