
This project is using Solr (http://lucene.apache.org/solr/) and Banana dashboard tool to analyze metadata catalog content.

## Features

* Advanced full-text search capabilities
* Online dashboard creation tool
* CSW harvesting


## Installing the application

Compile the application:

```
mvn clean install
```


Starting web application:

```
cd web
mvn tomcat7:run-war
```

Access the Solr admin page from http://localhost:8983/solr.
Access the dashboard from http://localhost:8983/solr/dashboard.

## Loading dashboards

Access the dashboard page, click load and choose dashboard configuration from
https://github.com/titellus/banana/tree/develop/src/app/dashboards

* Browse: Search for metadata records and filter your search easily (facets, INSPIRE themes and annexes charts).
* INSPIRE-Dashboard: Home page
* default: Monitoring reporting 2013 dashboard


## Harvesting records

Harvesting records from a CSW end-point:

```
cd harvesters
mvn camel:run
```


## Indexing records and indicators

The dashboard is based on 2 types of information:
* Metadata records following ISO19139 standard for geographic information
* INSPIRE indicators


Manually index XML records:

```
for f in *.xml; do
  echo "importing '$f' file..";
  curl "http://localhost:8983/solr/data/update/xslt?commit=true&tr=metadata-iso19139.xsl" \
     -H "Content-Type: text/xml; charset=utf-8" \
     --data-binary @$f
done
```

Manually indexing INSPIRE monitoring reporting:

```
for f in *.xml; do
  echo "importing '$f' file..";
  curl "http://localhost:8983/solr/data/update/xslt?commit=true&tr=inspire-monitoring-reporting.xsl" -H "Content-Type: text/xml; charset=utf-8" --data-binary @$f
done
```
