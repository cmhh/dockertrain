FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive

ENV SHELL /bin/bash

RUN apt-get update && \
  apt-get install -y --no-install-recommends \
    openjdk-8-jdk libssl-dev libcurl4-gnutls-dev curl net-tools netcat gnupg \
    openssh-client openssh-server vim zip unzip && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

RUN mkdir /root/.ssh
RUN ssh-keygen -t rsa -f /root/.ssh/id_rsa -P '' && \
    cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys 

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
ENV HADOOP_VERSION 2.8.0
ENV HADOOP_URL https://archive.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz
ENV HADOOP_PREFIX /opt/hadoop

RUN mkdir -p $HADOOP_PREFIX 

RUN curl -sL "${HADOOP_URL}" | gunzip | tar -x --strip-components=1 -C $HADOOP_PREFIX/ && \
  cp ${HADOOP_PREFIX}/etc/hadoop/mapred-site.xml.template ${HADOOP_PREFIX}/etc/hadoop/mapred-site.xml && \
  rm -rf $HADOOP_PREFIX/share/doc && \
  ln -s /opt/hadoop/etc/hadoop /etc/hadoop && \
  mkdir /opt/hadoop/logs && \
  mkdir /hadoop-data

ENV PATH $HADOOP_PREFIX/bin/:$PATH
ENV HADOOP_CONF_DIR /etc/hadoop
ENV MULTIHOMED_NETWORK 1
ENV USER root
ENV PATH $PATH:$HADOOP_PREFIX/bin
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:$HADOOP_PREFIX/lib/native

ADD entrypoint.sh /entrypoint.sh

RUN chmod a+x /entrypoint.sh

EXPOSE 22

ENTRYPOINT ["/entrypoint.sh"]