FROM frolvlad/alpine-glibc
LABEL maintainer="Gerald Schmidt <gerald1248@gmail.com>"
LABEL description="Unit tests for OpenShift clusters"
RUN apk add --no-cache curl bind-tools apache2-utils mysql-client postgresql-client jq
ADD downloads/shunit2 /usr/bin/
ADD downloads/oc /usr/bin/
ADD bin/openshift-unit /usr/bin/
RUN addgroup -S app && adduser -S -g app app && \
  mkdir /etc/openshift-unit.d && \
  chown app:app /etc/openshift-unit.d
ADD test/*_test /etc/openshift-unit.d/
WORKDIR /app
USER app
CMD ["/bin/sh", "-c", "while true; do sleep 60; done"]
