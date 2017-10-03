FROM ubuntu:16.04
MAINTAINER ROMAN TIRSKIKH
RUN apt-get update -y
RUN apt-get install -y nginx
COPY ./nginx/sources/tomcat.conf /etc/nginx/conf.d/
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
#CMD ["service", "nginx", "start"]
