# OpenShift unit tests

Cluster unit testing using `oc` and `shunit2`. The test pod mounts the test scripts and runs each one in turn.

Test scripts have cluster-reader access to the cluster. A range of tools including `oc`, `jq`, `curl`and `psql` is pre-installed.

## Fetch image from Docker Hub
```
$ ./oc-create.sh
project "openshift-unit" created
serviceaccount "openshift-unit" created
cronjob "openshift-unit" created
rolebinding "system:deployers" created
deploymentconfig "openshift-unit" created
clusterrolebinding "openshift-unit" created
limitrange "openshift-unit" created
resourcequota "openshift-unit" created
configmap "openshift-unit" created
$ oc get po
NAME                     READY     STATUS    RESTARTS   AGE
openshift-unit-1-bcp2d   1/1       Running   0          4m 
```
You can now wait for the CronJob to run the tests at ten past midnight (the default). If you'd rather not wait until midnight, enter:
```
$ oc exec openshift-unit-1-bcp2d openshift-unit
test_nodes_ready
test_nodes_no_warnings
test_project_quotas

Ran 5 tests.

OK
```

## Adding tests
To add your own tests, populate the folder `test` with additional files (containing functions and an instruction to add them to the test suite). To create an updated ConfigMap, run:
```
$ ./update-configmap.sh
```
This will create the configmap from the contents of the `test` folder.

## Cleanup
The script `cleanup.sh` will remove the project `openshift-unit` and the `cluster-reader` clusterrolebinding for serviceaccount `openshift-unit`.

## Building the image
Use the script `docker-build.sh` to create a bespoke test runner image. In many cases, the version of the `oc` client should be adjusted from `latest` to a version that matches your cluster.

Tag the image as desired and upload to Docker Hub or a private registry as appropriate.

## Note on versions
The default image on Docker Hub ships with the current stable build of the `oc` client. You may wish to adjust the version tag in the `docker-build.sh` script and create an image that matches your cluster exactly.

OpenShift versions prior to 3.9 (and Kubernetes versions prior to 1.8) offer limited support for CronJob objects (the version attribute has `v2alpha1`). If a process fails, the v2 alpha CronJob will keep spawning containers until a container returns 0. The problem is exacerbated by the fact that the CronJob object in these OpenShift builds does not recognise the cleanup properties reducing the number of `completed` or `error` pods kept.

To deal with this (and until most OpenShift installations are on 3.9 or higher), the CronJob always returns zero.
