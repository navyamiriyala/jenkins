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
                userRemoteConfigs: [[credentialsId: '661ec668-29c9-459b-a9ca-856cde7210ce', url: 'https://github.com/continuuminnovations-com/jenkins-code.git']]])
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
        stage('Create Release Tag') {
           steps {
             withCredentials([usernamePassword(credentialsId: 'github-token', passwordVariable: 'GITHUB_TOKEN', usernameVariable: 'GITHUB_USERNAME')]) {
               sh '''
               git checkout -b release
               git tag v${buildNumber}
               git push https://${GITHUB_USERNAME}:${GITHUB_TOKEN}@github.com/continuuminnovations-com/jenkins-code.git v${buildNumber}
               '''
             }
          }
        stage('Clone Release Tag') {
          steps {
            sh "git clone git@github.com:continuuminnovations-com/jenkins-code.git -b v${buildNumber}"
          }
        }
    }
}
          
        
