FROM ubuntu/tomcat:v1
MAINTAINER ROMAN TIRSKIKH
#VOLUME /opt/tomcat/webapps
COPY ./resources/sample.war /opt/tomcat/webapps/
CMD sleep infinity
