FROM ubuntu:latest

RUN apt update && \
    apt install -y openjdk-11-jdk wget git && \
    useradd -m -d /var/jenkins_home jenkins

WORKDIR /var/jenkins_home

COPY jenkins.war ./

EXPOSE 8080
EXPOSE 50000

CMD ["java", "-jar", "jenkins.war"]
