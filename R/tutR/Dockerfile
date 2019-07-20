FROM ubuntu:19.04

ENV DEBIAN_FRONTEND noninteractive

ENV R_BASE_VERSION 3.5.2

ENV LC_ALL en_US.UTF-8

ENV LANG en_US.UTF-8

RUN apt-get update && \ 
  apt-get install -y --no-install-recommends \
    libcurl4-gnutls-dev libssl-dev wget ca-certificates locales libxml2-dev \
    nginx gdebi-core \
    r-base=${R_BASE_VERSION}* r-base-dev=${R_BASE_VERSION}* r-recommended=${R_BASE_VERSION}* pandoc && \
  apt-get clean && \
  echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
  locale-gen en_US.utf8 && \
  /usr/sbin/update-locale LANG=en_US.UTF-8 && \
  wget https://download2.rstudio.org/server/bionic/amd64/rstudio-server-1.2.1335-amd64.deb && \
  gdebi --non-interactive rstudio-server-1.2.1335-amd64.deb && \
  rm rstudio-server-1.2.1335-amd64.deb && \
  adduser --disabled-password --gecos "" guest && \
  usermod --password $(openssl passwd -1 guest) guest && \
  printf "\noptions(repos = c(CRAN = 'https://cloud.r-project.org/'), download.file.method = 'libcurl')" >> \
    /etc/R/Rprofile.site && \
  printf "\nlocal({\n  options(shiny.port = 3838, shiny.host = '0.0.0.0')\n})\n" >> \
    /etc/R/Rprofile.site && \
  R -e "install.packages(c('tidyverse', 'data.table', 'devtools', 'shiny', 'rmarkdown'), ask = FALSE)" && \
  R -e "devtools::install_github('https://github.com/rstudio/learnr', ask = FALSE)" 

COPY tutR /tutR

COPY scripts/addtutorials.sh /addtutorials.sh
COPY scripts/startall.sh /startall.sh

COPY conf/default /etc/nginx/sites-available/default

COPY html /var/www/html

RUN chmod +x /addtutorials.sh && \
  chmod +x /startall.sh && \
  R -e "devtools::install_local('/tutR')"  

EXPOSE 8080

CMD /addtutorials.sh && \
  service nginx start && \
  service rstudio-server start && \
  /startall.sh && \
  tail -F /var/log/nginx/access.log
