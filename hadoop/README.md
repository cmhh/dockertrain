## Hadoop Cluster via Docker

This directory can be used to assemble a working Hadoop cluster from Docker images.  It is closer to a real-life cluster than the `bigdata` environment, with several workers for each of Hadoop and Spark; and it would allow testing of more realistic `spark-submit` jobs and the like.

The prerequisites are [Docker](https://www.docker.com) and [docker-compose](https://docs.docker.com/compose/install/).  To get going, simply:

```bash
cd docker
chmod +x build.sh # make the script executable
./build.sh # build all the images... can take a while
docker-compose up -d # start the cluster as a daemon
docker-compose down # stop the cluster
```

Any of the images can be accessed from within a terminal.  For example, to get terminal access to `namenode` via a terminal:

```bash
docker exec -it namenode /bin/bash
```

To get the IP addresses of all the individual containers, run:

```bash
docker network inspect hadoop_default
```

Note the Dockerfiles were stolen in equal parts from [Big Data Europe](https://github.com/big-data-europe) and [U-hopper/hadoop-docker](https://bitbucket.org/uhopper/hadoop-docker/src/master/).
