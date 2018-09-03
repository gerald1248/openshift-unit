FROM openshift/base-centos7:latest
LABEL maintainer="Gerald Schmidt <gerald1248@gmail.com>"
LABEL description="Automated tests for OpenShift clusters"
RUN yum install -y epel-release zip
RUN yum install -y jq
RUN yum install -y centos-release-openshift-origin310 && \
  yum install -y origin-clients
RUN groupadd app && useradd -g app app && \
        mkdir /app && \
        mkdir /etc/openshift-unit.d && \
        chmod 777 /app && \
        chown app:app /etc/openshift-unit.d
RUN curl -o /usr/bin/shunit2 https://raw.githubusercontent.com/kward/shunit2/master/shunit2
ADD test/*_test /etc/openshift-unit.d/
ADD bin/openshift-unit /usr/bin/
RUN chmod +x /usr/bin/openshift-unit
WORKDIR /app
USER app
CMD ["/bin/sh", "-c", "while true; do sleep 60; done"]
