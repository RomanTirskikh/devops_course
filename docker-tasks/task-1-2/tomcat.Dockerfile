FROM ubuntu:14.04
MAINTAINER ROMAN TIRSKIKH
RUN apt-get update -y
RUN apt-get install -y default-jdk default-jre wget unzip tree
ENV RUN_USER="tomcat"
ENV RUN_GROUP="tomcat"
ENV TOMCAT_VERSION="7.0.81"
ENV CATALINA_HOME="/opt/tomcat"
RUN groupadd -r ${RUN_GROUP} && useradd -g ${RUN_GROUP} -d ${CATALINA_HOME} -s /bin/bash ${RUN_USER}
RUN wget http://mirror.linux-ia64.org/apache/tomcat/tomcat-7/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.zip -O /opt/tomcat.zip
RUN unzip /opt/tomcat.zip
RUN rm /opt/tomcat.zip
RUN mv -v apache-tomcat* $CATALINA_HOME
RUN chown -R tomcat:tomcat $CATALINA_HOME
RUN chmod -R +x  $CATALINA_HOME
#RUN ls -lah $CATALINA_HOME
#ADD resources/run.sh /usr/local/bin/run
#RUN chmod 777 /usr/local/bin/run
#EXPOSE 8080
#CMD ["/usr/local/bin/run"]
CMD ["/opt/tomcat/bin/catalina.sh", "run"]
