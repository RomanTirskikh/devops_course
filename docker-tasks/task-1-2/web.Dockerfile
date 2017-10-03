FROM ubuntu:14.04
MAINTAINER ROMAN TIRSKIKH
RUN apt-get update -y
RUN apt-get install -y nginx
COPY ./resources/tomcat.conf /etc/nginx/conf.d/
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
#CMD ["service", "nginx", "start"]
