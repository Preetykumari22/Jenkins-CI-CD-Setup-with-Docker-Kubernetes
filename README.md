# Jenkins-CI-CD-Setup-with-Docker-Kubernetes

This project demonstrates a complete hands-on CI/CD pipeline setup using Jenkins, Docker, and Kubernetes (EKS) **without using any pre-built Jenkins Docker images**. The Jenkins master runs inside a manually created Docker container, and Kubernetes is used for dynamic Jenkins agent provisioning.


## 🔧 Technologies Used

* Docker
* Jenkins (via `jenkins.war`)
* Kubernetes (AWS EKS)
* EC2 (Ubuntu)
* Shell CLI
* GitHub


## 🚀 Project Structure

### Step 1: Jenkins Installation in Docker (Manual Setup)

```bash
# Create Dockerfile (Ubuntu-based Jenkins setup)
FROM ubuntu:latest

RUN apt update && \
    apt install -y openjdk-11-jdk wget git && \
    useradd -m -d /var/jenkins_home jenkins

WORKDIR /var/jenkins_home

COPY jenkins.war ./

EXPOSE 8080
EXPOSE 50000

CMD ["java", "-jar", "jenkins.war"]
```

```bash
# Build and run Jenkins Docker container
$ docker build -t manual-jenkins .
$ docker run -d -p 8080:8080 -p 50000:50000 --name myjenkins manual-jenkins
```

### Step 2: Initial Jenkins Setup

* Unlock Jenkins via terminal output password
* Install required plugins:

  * Kubernetes
  * Docker Pipeline
  * Pipeline Utility Steps
  * AWS Credentials
  * GitHub Integration


## ☘️ Kubernetes Integration (EKS)

### Step 3: Connect Jenkins to Kubernetes

```bash
# Create and connect to EKS cluster
$ aws eks update-kubeconfig --name my-cluster
$ kubectl cluster-info
$ kubectl get nodes
```

### Step 4: Copy kubeconfig into Jenkins container

```bash
$ docker exec -it myjenkins mkdir -p /var/jenkins_home/.kube
$ docker cp ~/.kube/config myjenkins:/var/jenkins_home/.kube/config
```

### Step 5: Configure Kubernetes Cloud in Jenkins

* Kubernetes URL: EKS API endpoint
* Namespace: default
* Credentials: Jenkins credential with kubeconfig or AWS IAM
* Jenkins URL: `http://<jenkins-host>:8080`
* Pod Template: Defined with label `jenkins-slave`


## 🔁 Jenkins Pipeline Job

### Step 6: Create and run Jenkins pipeline

```groovy
pipeline {
    agent {
        kubernetes {
            label 'jenkins-slave'
            yaml '''
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: jnlp
    image: jenkins/inbound-agent
    args: ['\$(JENKINS_SECRET)', '\$(JENKINS_NAME)']
    tty: true
'''
        }
    }
    stages {
        stage('Build') {
            steps {
                sh 'echo Building project...'
            }
        }
    }
}
```


## 🙌 Conclusion

* Manually installing Jenkins helped me understand every layer of the stack
* Integrated dynamic provisioning of Kubernetes agents
* Built a solid base for scalable CI/CD pipelines using open-source tools

