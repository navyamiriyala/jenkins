pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                checkout([$class: 'GitSCM', 
                branches: [[name: '*/main']],
                userRemoteConfigs: [[credentialsId: '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', url: 'https://github.com/continuuminnovations-com/jenkins-code.git']]])
            }
        }
               
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t hello-world-python .'
            }
        }
        stage('Run Docker Image') {
            steps {
                sh 'docker run hello-world-python'
            }
        }
    }
}
