pipeline {
  agent any
  environment {
        version = "v1.0.0"
        github_org = "navyamiriyala"
        repository = "jenkins"
    }
    stages {
        stage('Checkout') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/main']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'GITHUB_CREDENTIALS_ID', url: 'https://github.com/navyamiriyala/jenkins.git']]])
            }
        }
        stage('Create Git Tag') {
            steps {
                script {
                    def parts = version.tokenize(".")
                    def major = parts[0].substring(1).toInteger()
                    def minor = parts[1].toInteger()
                    def patch = parts[2].toInteger()
                    def newVersion = "v${major}.${minor}.${patch + env.BUILD_NUMBER}"
                    sh "git tag -a ${newVersion} -m 'Tag created by Jenkins build'"
                }
            }
        }
	stage("Retrieve GitHub Token") {
		steps {
		   withCredentials([aws(credentialsId: 'AWS_ACCESS_KEY_ID', accessKeyIdVariable: 'AWS_ACCESS_KEY_ID', secretAccessKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
		      sh """
		        export GITHUB_TOKEN=$(aws secretsmanager get-secret-value --secret-id github-token --query SecretString --output text --region us-west-1 --access-key $AWS_ACCESS_KEY_ID --secret-key $AWS_SECRET_ACCESS_KEY)
		      """
		   }
		}
	}
        stage('Push Git Tag') {
            steps {
                script {
                    def parts = version.tokenize(".")
                    def major = parts[0].substring(1).toInteger()
                    def minor = parts[1].toInteger()
                    def patch = parts[2].toInteger()
                    def newVersion = "v${major}.${minor}.${patch + env.BUILD_NUMBER}"
                    withCredentials([usernamePassword(credentialsId: "GITHUB_CREDENTIALS_ID", passwordVariable: "githubPassword", usernameVariable: "githubUsername")]) {
                        sh "git push https://${githubUsername}:${githubPassword}@github.com/navyamiriyala/jenkins.git ${newVersion}"
                    }
                }
            }
        }
        stage("Create GitHub Release") {
            steps {
                script {
                    // Retrieve the latest tag from the GitHub repository
                    def latestTag = sh(returnStdout: true, script: 'git describe --abbrev=0 --tags').trim()
                    echo "Latest tag: ${latestTag}"
                    sh "curl -X POST -H 'Authorization: token ${GITHUB_TOKEN}' -H 'Content-Type: application/json'
		}
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
        stage('Push to ECR') {
            steps {
                withCredentials([aws(credentialsId: 'AWS_ACCESS_KEY_ID', region: 'us-east-1')]) {
                    sh 'aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 015838347042.dkr.ecr.us-east-1.amazonaws.com'
                    sh 'docker images'
                    sh 'docker tag hello-world-python:latest 015838347042.dkr.ecr.us-east-1.amazonaws.com/jenkins:latest'
                    sh 'docker push 015838347042.dkr.ecr.us-east-1.amazonaws.com/jenkins:latest'
                }
            }
        }
    }
}
