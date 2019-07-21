FROM hadoop-base

ENV SPARK_VERSION 2.4.2

ENV SPARK_BIN_URL https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop2.7.tgz

ENV SPARK_HOME /opt/spark

RUN set -x \
    && curl -fSL "$SPARK_BIN_URL" -o /tmp/spark.tar.gz \
    && tar -xvf /tmp/spark.tar.gz -C /opt \
    && mv /opt/spark-$SPARK_VERSION-* $SPARK_HOME \
    && rm -f /tmp/spark.tar.gz

WORKDIR $SPARK_HOME
ENV PATH $SPARK_HOME/bin:$PATH

ADD spark-entrypoint.sh /
ADD spark-historyserver.sh /
ADD spark-master.sh /
ADD spark-slave.sh /

RUN chmod a+x \
    /spark-entrypoint.sh \
    /spark-historyserver.sh \
    /spark-master.sh \
    /spark-slave.sh
    
RUN echo "export SPARK_DIST_CLASSPATH=$(hadoop classpath)" >> /opt/spark/conf/spark-env.sh

ENTRYPOINT ["/spark-entrypoint.sh"]