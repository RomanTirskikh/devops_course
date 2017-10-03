FROM openjdk:8
MAINTAINER ROMAN TIRSKIKH

ENV GRADLE_HOME /opt/gradle/gradle-4.2/
ENV GRADLE_VERSION 4.2
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/gradle/gradle-4.2/bin

RUN apt-get -y update
RUN apt-get install -y vim wget unzip git ssh
RUN wget --no-check-certificate "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" -O gradle.zip
RUN mkdir /opt/gradle
RUN unzip -d /opt/gradle gradle.zip
RUN rm gradle.zip
RUN mkdir -p /var/jenkins_home
RUN useradd jenkins -d /var/jenkins_home -s /bin/bash
RUN echo "export PATH=$PATH:/opt/gradle/gradle-4.2/bin" >> /var/jenkins_home/.bashrc
RUN echo "export PATH=$PATH:/opt/gradle/gradle-4.2/bin" >> /var/jenkins_home/.bash_profile
RUN mkdir -p /var/jenkins_home/.ssh
RUN chown -R jenkins:jenkins /var/jenkins_home
RUN chmod 700 /var/jenkins_home/.ssh
RUN mkdir -p /var/run/sshd
RUN chmod 755 /var/run/sshd

VOLUME /var/jenkins_home/.ssh

EXPOSE 22
CMD rm /var/jenkins_home/.ssh/*; ssh-keygen -q -t rsa -N '' -f /var/jenkins_home/.ssh/id_rsa; cp /var/jenkins_home/.ssh/id_rsa.pub /var/jenkins_home/.ssh/authorized_keys; chmod 600 /var/jenkins_home/.ssh/authorized_keys; chown -R jenkins:jenkins /var/jenkins_home/.ssh; /usr/sbin/sshd -D
