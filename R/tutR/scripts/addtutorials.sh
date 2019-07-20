#! /usr/bin/env bash

tutr_path='/tutR/inst/tutorials'
port=3000

getTitle () { echo `cat ${tutr_path}/$1/$1.title`; }
getDescription () { echo `cat ${tutr_path}/$1/$1.description`; }

makeCard () {
    result="\n<div class=card data-url=\"/lessons/$1\" onclick=\"window.open('/lessons/$1','mywindow');\" style=\"cursor: pointer;\">"
    result="${result}\n  <div class=card-bg><img src=img/bg00.png></div>"      
    result="${result}\n  <div class=card-title>`getTitle $1`</div>"   
    result="${result}\n  <div class=card-body>`getDescription $1`</div>"   
    result="${result}\n</div>\n"
    echo $result
}

makeLocation () {
    result="\nlocation /lessons/$1/ {"
    result="${result}\n  proxy_pass http://127.0.0.1:$2/;"
    result="${result}\n  proxy_http_version 1.1;"
    result="${result}\n  proxy_set_header Upgrade \$http_upgrade;"
    result="${result}\n  proxy_set_header Connection \"upgrade\";"
    result="${result}\n  proxy_read_timeout 20d;"
    result="${result}\n}\n"
    echo $result
}

makeTutorial () {
    result="R -e \"learnr::run_tutorial('$1', package = 'tutR', shiny_args = list(port = $2))\" \&\n"
    echo $result
}

locations=""
tutorials=""
fundamentals=""
tidyverse=""
datascience=""
spatial=""
special=""

for tut in base dataframe programming-1 programming-2
do
  port=$((port + 1))
  fundamentals="${fundamentals}`makeCard ${tut}`"
  locations="${locations}`makeLocation ${tut} ${port}`"
  tutorials="${tutorials}`makeTutorial ${tut} ${port}`"
done

for tut in tidydata ggplot2
do
  port=$((port + 1))
  tidyverse="${tidyverse}`makeCard ${tut}`"
  locations="${locations}`makeLocation ${tut} ${port}`"
  tutorials="${tutorials}`makeTutorial ${tut} ${port}`"
done

for tut in ml-1
do
  port=$((port + 1))
  datascience="${datascience}`makeCard ${tut}`"
  locations="${locations}`makeLocation ${tut} ${port}`"
  tutorials="${tutorials}`makeTutorial ${tut} ${port}`"
done

for tut in spatial-1 spatial-2
do
  port=$((port + 1))
  spatial="${spatial}`makeCard ${tut}`"
  locations="${locations}`makeLocation ${tut} ${port}`"
  tutorials="${tutorials}`makeTutorial ${tut} ${port}`"
done

for tut in datatable rcpp rjava
do
  port=$((port + 1))
  special="${special}`makeCard ${tut}`"
  locations="${locations}`makeLocation ${tut} ${port}`"
  tutorials="${tutorials}`makeTutorial ${tut} ${port}`"
done

sed -i "s|{{ locations }}|${locations}|g" /etc/nginx/sites-available/default
sed -i "s|{{ tutorials }}|${tutorials}|g" /startall.sh

sed -i "s|{{ fundamentals }}|${fundamentals}|g" /var/www/html/index.html
sed -i "s|{{ tidyverse }}|${tidyverse}|g" /var/www/html/index.html
sed -i "s|{{ datascience }}|${datascience}|g" /var/www/html/index.html
sed -i "s|{{ spatial }}|${spatial}|g" /var/www/html/index.html
sed -i "s|{{ special }}|${special}|g" /var/www/html/index.html