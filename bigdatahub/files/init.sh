#!/usr/bin/env bash

service ssh start
service postgresql start

hdfs namenode -format
/opt/hadoop/sbin/start-all.sh
/opt/spark/sbin/start-master.sh
/opt/spark/sbin/start-slave.sh localhost:7077

if [ ! -d "/data/hive/metastore_db" ]; then
  echo "Setting up metastore"
  cd /data/hive
  $HIVE_HOME/bin/schematool -dbType derby -initSchema 
  cd
fi

$SPARK_HOME/sbin/start-thriftserver.sh --master "local[4]" --conf "spark.sql.shuffle.partitions=4" 
$HIVE_HOME/hcatalog/sbin/hcat_server.sh start 

hive -f /data/nycflights.sql
source /data/nycflights.sh

cd /notebooks && jupyterhub -f /etc/jupyter/jupyterhub_config.py

sleep 20