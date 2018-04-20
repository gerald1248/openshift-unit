#!/bin/sh

find openshift -name \*.yml -type f -exec oc create -f {} \;
