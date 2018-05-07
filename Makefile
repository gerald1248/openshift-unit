VERSION=0.1.0

create:
	./create.sh && ./update-configmap.sh

test:
	cd bin; ./openshift-unit_test 

clean:
	./clean.sh

build-docker-image:
	./build-docker-image.sh

update-configmap:
	./update-configmap.sh

default: create

.PHONY: test
