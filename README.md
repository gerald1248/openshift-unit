# OpenShift unit tests

Cluster unit testing using `oc` and `shunit2`. The test pod mounts the test scripts and runs each one in turn.

Test scripts have cluster-reader access to the cluster. A range of tools including `oc`, `jq`, `curl`and `psql` is pre-installed.

## Fetch image from Docker Hub
```
$ ./oc-create.sh
$ oc get po
NAME                     READY     STATUS    RESTARTS   AGE
openshift-unit-1-bcp2d   1/1       Running   0          4m$ 
$ oc exec openshift-unit-1-bcp2d openshift-unit
...
OK
```

## Adding tests
To add your own tests, populate the folder `test` with additional scripts. To create an updated ConfigMap, run:
```
$ ./update-configmap.sh
```
This will create (or replace) the configmap from the contents of the `test` folder.

## Building the image
Use the script `docker-build.sh` to create a bespoke test runner image. In many cases, the version of the `oc` client should be adjusted from `latest` to a version that matches your cluster.

Tag the image as desired and upload to Docker Hub or a private registry as appropriate.
