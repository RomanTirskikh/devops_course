#!/bin/bash
docker build -t ubuntu/nginx:v1 -f ./nginx/web.Dockerfile .
docker build -t ubuntu/tomcat:v1 -f ./tomcat/tomcat.Dockerfile .
docker build -t ubuntu/webapp:v1 -f ./webapp/application.Dockerfile .
docker run --rm -d --name webapp ubuntu/webapp:v1
docker run --rm -d --name tomcat --volumes-from webapp ubuntu/tomcat:v1
docker run --rm -d --name nginx --link tomcat:tomcat -p 81:80 ubuntu/nginx:v1
docker images
docker ps
