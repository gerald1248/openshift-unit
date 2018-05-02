VERSION=0.1.0

create:
	./oc-create.sh

test:
	cd bin; ./openshift-unit_test 
clean:
	./cleanup.sh

build:
	./docker-build.sh

update:
	./update-configmap.sh

default: create

.PHONY: test
