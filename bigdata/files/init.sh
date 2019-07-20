#!/usr/bin/env bash

if [ ! -d "/data/hive/metastore_db" ]; then
  echo "Setting up metastore"
  cd /data/hive
  $HIVE_HOME/bin/schematool -dbType derby -initSchema 
  cd
fi

$SPARK_HOME/sbin/start-thriftserver.sh --master "local[4]" --conf "spark.sql.shuffle.partitions=4" 
$HIVE_HOME/hcatalog/sbin/hcat_server.sh start 

hive -f /data/nycflights.sql

mkdir -p ${HOME}/.jupyter
touch ${HOME}/.jupyter/jupyter_notebook_config.py 
echo "c.NotebookApp.open_browser = False" >> ${HOME}/.jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.ip = '0.0.0.0'" >> ${HOME}/.jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.password = u''" >> ${HOME}/.jupyter/jupyter_notebook_config.py 
echo "c.NotebookApp.token = ''" >> ${HOME}/.jupyter/jupyter_notebook_config.py
cd /notebooks && jupyter-lab --ip=0.0.0.0 --allow-root

sleep 20