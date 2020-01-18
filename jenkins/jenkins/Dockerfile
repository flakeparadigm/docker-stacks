FROM jenkins/jenkins:lts-jdk11
ARG DOCKER_GROUP_ID
USER root

RUN groupadd -g ${DOCKER_GROUP_ID} docker; \
    usermod -a -G docker jenkins;

USER jenkins
