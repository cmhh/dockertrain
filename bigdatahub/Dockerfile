FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive
ENV R_BASE_VERSION 3.4.4
ENV SBT_VERSION 1.2.8
ENV HADOOP_VERSION 3.2.0
ENV HIVE_VERSION 2.3.5
ENV SPARK_VERSION 2.4.3
ENV PATH $PATH:~/.local/bin
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV SHELL /bin/bash

# install necessary packages
RUN apt-get update && \
  apt-get install -y \
    libssl-dev libgit2-dev libssl-dev libcurl4-gnutls-dev libxml2-dev curl\
    openssh-server openssh-client \
    openjdk-8-jdk python3-pip git vim postgresql libpostgresql-jdbc-java \
    r-base=${R_BASE_VERSION}* r-base-dev=${R_BASE_VERSION}* \
    xz-utils && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

RUN mkdir /root/.ssh && \
  ssh-keygen -t rsa -f /root/.ssh/id_rsa -P '' && \
  cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys

# install sbt
RUN curl -Lo /tmp/sbt.tgz https://piccolo.link/sbt-${SBT_VERSION}.tgz && \
  tar -xvf /tmp/sbt.tgz -C /opt && \
  rm -f /tmp/sbt.tgz
ENV SBT_HOME /opt/sbt
ENV PATH $PATH:$SBT_HOME/bin

# install Hadoop
ENV HADOOP_HOME /opt/hadoop
ENV HADOOP_CONF_DIR=$HADOOP_HOME/conf
ENV PATH $PATH:$HADOOP_HOME/bin
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HADOOP_HOME/lib/native
RUN mkdir -p $HADOOP_HOME && \
  curl -sL \
    "https://archive.apache.org/dist/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz" | \
    gunzip | tar -x --strip-components=1 -C $HADOOP_HOME/ && \
  rm -rf $HADOOP_HOME/share/doc && \
  chown -R root:root $HADOOP_HOME && \
  mkdir -p $HADOOP_HOME/logs && \
  ln -s $HADOOP_HOME/etc/hadoop $HADOOP_CONF_DIR && \
  chmod 777 $HADOOP_HOME/logs 

# install Hive
ENV HIVE_HOME=/opt/hive
ENV HIVE_CONF_DIR=$HIVE_HOME/conf
ENV PATH $PATH:$HIVE_HOME/bin
ENV HDFS_NAMENODE_USER root
ENV HDFS_DATANODE_USER root
ENV HDFS_SECONDARYNAMENODE_USER root
ENV YARN_NODEMANAGER_USER root
ENV YARN_RESOURCEMANAGER_USER root
RUN mkdir -p $HIVE_HOME && \
  curl -sL \
    "https://archive.apache.org/dist/hive/hive-$HIVE_VERSION/apache-hive-$HIVE_VERSION-bin.tar.gz" | \
    gunzip | tar -x --strip-components=1 -C $HIVE_HOME/ && \
  chown -R root:root $HIVE_HOME/ && \
  mkdir -p $HIVE_HOME/hcatalog/var/log && \
  mkdir -p $HIVE_HOME/var/log && \
  mkdir -p /data/hive/ && \
  mkdir -p $HIVE_CONF_DIR && \
  chmod 777 $HIVE_HOME/hcatalog/var/log && \
  chmod 777 $HIVE_HOME/var/log && \
  mkdir ${HOME}/namenode && mkdir ${HOME}/datanode

# install spark
ENV SPARK_HOME=/opt/spark
ENV SPARK_CONF_DIR=$SPARK_HOME/conf
ENV PATH $PATH:$SPARK_HOME/bin
RUN mkdir -p $SPARK_HOME && \
  curl -sL \
    "https://archive.apache.org/dist/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop2.7.tgz" | \
    gunzip | tar -x --strip-components=1 -C $SPARK_HOME/ && \
  chown -R root:root $SPARK_HOME && \
  mkdir -p $SPARK_HOME/logs && \
  mkdir -p $SPARK_HOME/work && \
  mkdir -p $SPARK_CONF_DIR && \
  chmod 777 $SPARK_HOME/logs && \
  chmod 777 $SPARK_HOME/work && \
  chmod 777 $SPARK_CONF_DIR

# configure R
RUN R CMD javareconf && \
  echo 'options(repos = c(CRAN = "https://cloud.r-project.org/"), download.file.method = "libcurl")' >> /etc/R/Rprofile.site && \
  R -e "install.packages(c('rJava', 'RJDBC', 'devtools', 'sparklyr', 'ggplot2', 'dplyr', 'data.table'))" && \
	rm -rf /tmp/downloaded_packages/ /tmp/*.rds 

# install JupyterHub etc. w/ pyspark
ENV PYTHONPATH=$SPARK_HOME/python:$PYTHONPATH
ENV PYSPARK_DRIVER_PYTHON="jupyter"
ENV PYSPARK_DRIVER_PYTHON_OPTS="lab"
ENV PYSPARK_PYTHON=python3
ENV PATH $PATH:/usr/local/node/bin

RUN wget https://nodejs.org/dist/v12.16.0/node-v12.16.0-linux-x64.tar.xz && \
  mkdir -p /usr/local/node && tar -xJf node-v12.16.0-linux-x64.tar.xz -C /usr/local/node --strip-components=1 && \
  rm node-v12.16.0-linux-x64.tar.xz && \
  npm install -g configurable-http-proxy && \
  pip3 install --upgrade pip && \
  pip3 install jupyterhub jupyterlab tensorflow keras pandas numpy matplotlib py4j RISE && \
  mkdir -p /notebooks && \
  R -e "install.packages('https://cran.r-project.org/src/contrib/Archive/pbdZMQ/pbdZMQ_0.3-3.tar.gz', repos = NULL, type = 'source')" && \
  R -e "devtools::install_github('IRkernel/IRkernel')" && \
  R -e "IRkernel::installspec(prefix = '/usr/local')" && \
  R -e "devtools::install_github('apache/spark@v${SPARK_VERSION}', subdir='R/pkg')" && \
	rm -rf /tmp/downloaded_packages/ /tmp/*.rds 

# install almond kernel
RUN curl -Lo coursier https://git.io/coursier-cli && \
  chmod +x coursier && \
  SCALA_VERSION=2.11.12 ALMOND_VERSION=0.6.0 && \
  ./coursier bootstrap \
    -r jitpack \
    -i user -I user:sh.almond:scala-kernel-api_$SCALA_VERSION:$ALMOND_VERSION \
    sh.almond:scala-kernel_$SCALA_VERSION:$ALMOND_VERSION \
    --sources --default=true \
    -o almond-scala-2.11 && \
  ./almond-scala-2.11 --install --global --id scala211 --display-name "Scala (2.11)" && \
  rm -f almond-scala-2.11  && \
  SCALA_VERSION=2.12.8 && \
  ./coursier bootstrap \
    -r jitpack \
    -i user -I user:sh.almond:scala-kernel-api_$SCALA_VERSION:$ALMOND_VERSION \
    sh.almond:scala-kernel_$SCALA_VERSION:$ALMOND_VERSION \
    --sources --default=true \
    -o almond-scala-2.12 && \
  ./almond-scala-2.12 --install --global --id scala212 --display-name "Scala (2.12)" && \
  rm -f almond-scala-2.12 && \
  SCALA_VERSION=2.13.0 && \
  ./coursier bootstrap \
    -r jitpack \
    -i user -I user:sh.almond:scala-kernel-api_$SCALA_VERSION:$ALMOND_VERSION \
    sh.almond:scala-kernel_$SCALA_VERSION:$ALMOND_VERSION \
    --sources --default=true \
    -o almond-scala-2.13 && \
  ./almond-scala-2.13 --install --global --id scala213 --display-name "Scala (2.13)" && \
  rm -f almond-scala-2.13 && \
  rm -f coursier 

# other configuration
RUN cd $HIVE_HOME/lib && \
  ln -s $SPARK_HOME/jars/scala-library* && \
  ln -s $SPARK_HOME/jars/spark-core* && \
  ln -s $SPARK_HOME/jars/spark-network-common* && \
  ln -s $SPARK_HOME/jars/chill-* && \
  ln -s $SPARK_HOME/jars/chill_* && \
  ln -s $SPARK_HOME/jars/jackson-module-paranamer* && \
  ln -s $SPARK_HOME/jars/jackson-module-scala* && \
  ln -s $SPARK_HOME/jars/jersey-container-servlet-core* && \
  ln -s $SPARK_HOME/jars/jersey-server* && \  
  ln -s $SPARK_HOME/jars/json4s-ast* && \
  ln -s $SPARK_HOME/jars/kryo-shaded* && \
  ln -s $SPARK_HOME/jars/minlog* && \
  ln -s $SPARK_HOME/jars/scala-xml* && \
  ln -s $SPARK_HOME/jars/spark-launcher* && \
  ln -s $SPARK_HOME/jars/spark-network-shuffle* && \
  ln -s $SPARK_HOME/jars/spark-unsafe* && \
  ln -s $SPARK_HOME/jars/xbean-asm5-shaded* 

ADD files/core-site.xml $HADOOP_CONF_DIR/
ADD files/hadoop-env.sh $HADOOP_CONF_DIR/
ADD files/hdfs-site.xml $HADOOP_CONF_DIR/
ADD files/hive-site.xml $HIVE_CONF_DIR/
ADD files/hive-site.xml $SPARK_CONF_DIR/
ADD files/pg_hba.conf /etc/postgresql/10/main/

ADD files/init.sh /
ADD data /data
ADD files/jupyterhub_config.py /etc/jupyter/
ADD files/jupyter_notebook_config.py /etc/jupyter/
COPY files/custom /root/.jupyter/custom

COPY notebooks notebooks

RUN useradd -ms /bin/bash guest1 && \
  echo 'guest1:guest1' | chpasswd && \
  cp -R /notebooks /home/guest1 && \
  chown -R guest1 /home/guest1/notebooks && chgrp -R guest1 /home/guest1/notebooks && \
  useradd -ms /bin/bash guest2 && \
  echo 'guest2:guest2' | chpasswd && \
  cp -R /notebooks /home/guest2 && \
  chown -R guest2 /home/guest2/notebooks && chgrp -R guest2 /home/guest2/notebooks && \
  useradd -ms /bin/bash guest3 && \
  echo 'guest3:guest3' | chpasswd && \
  cp -R /notebooks /home/guest3 && \
  chown -R guest3 /home/guest3/notebooks && chgrp -R guest3 /home/guest3/notebooks && \
  useradd -ms /bin/bash guest4 && \
  echo 'guest4:guest4' | chpasswd && \
  cp -R /notebooks /home/guest4 && \
  chown -R guest4 /home/guest4/notebooks && chgrp -R guest4 /home/guest4/notebooks && \
  useradd -ms /bin/bash guest5 && \
  echo 'guest5:guest5' | chpasswd && \
  cp -R /notebooks /home/guest5 && \
  chown -R guest5 /home/guest5/notebooks && chgrp -R guest5 /home/guest5/notebooks 

EXPOSE 22 
EXPOSE 4040
EXPOSE 8000
EXPOSE 8080
EXPOSE 8888
EXPOSE 9083
EXPOSE 10000

ENTRYPOINT ["/init.sh"]
