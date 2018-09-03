create:
	./create.sh

test:
	cd bin; ./openshift-unit_test 

clean:
	./clean.sh

update-configmap:
	./update-configmap.sh

default: create

.PHONY: test
