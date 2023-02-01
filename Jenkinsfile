pipeline {
  agent any
  environment {
    buildNumber = "${BUILD_NUMBER}"
  }
    stages {
        stage('Checkout') {
            steps {
                checkout([$class: 'GitSCM', 
                branches: [[name: '*/main']],
                userRemoteConfigs: [[credentialsId: '038d6150-b196-45a7-9b38-6b1f0d559d02', url: 'https://github.com/navyamiriyala/jenkins.git']]])
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
