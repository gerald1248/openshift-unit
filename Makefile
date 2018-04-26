VERSION=0.1.0

create:
	./oc-create.sh

clean:
	./cleanup.sh

build:
	./docker-build.sh

default: create
