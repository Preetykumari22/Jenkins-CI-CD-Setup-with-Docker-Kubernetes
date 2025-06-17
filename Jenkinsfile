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
    args: ['$(JENKINS_SECRET)', '$(JENKINS_NAME)']
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
