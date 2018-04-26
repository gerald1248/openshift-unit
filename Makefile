VERSION=0.1.0

create:
	./oc-create.sh

clean:
	./cleanup.sh

build:
	./docker-build.sh

update:
	./update-configmap.sh

default: create
