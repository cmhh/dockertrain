## Building Training Environments with Docker

This repository contains prototypes for self-contained learning environments, containerised using Docker.  There are currently two basic environments:

* R - for learning R
* bigdata - mostly for learning Apache Spark, but with support for Hadoop and Hive included.

The R environment consists of the following:

* R, along with a number of dependent packages
* a package containing tutorials written with the `learnr` template
* an initialisation script which starts each tutorial on a different port
* a webserver (nginx) configured to:
    - reverse proxy for each tutorial
    - serve an index page with links to all available tuorials
* RStudio Server for ad hoc experimentation.

This is just a proof of concept, and the tutorials themselves aren't well fleshed-out.  They'll be added to over time.

The 'Big Data' environment consists of:

* Hadoop
* Hive
* Spark
* R
* Python3
* JupyterLab with Python, R, and Scala kernels
* pre-populated Hive tables
* a collection of other data files&ndash;CSV, parquet, etc. (not yet, actually... but soon)
* Jupyter notebooks covering various topics.

Again, this is just a proof of concept, and the tutorials / notebooks aren't well fleshed-out.  Again, they'll be added to over time.