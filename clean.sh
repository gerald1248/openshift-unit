#!/bin/sh
oc delete --ignore-not-found project/openshift-unit
oc delete --ignore-not-found clusterrolebinding/openshift-unit
