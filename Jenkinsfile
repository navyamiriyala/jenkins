pipeline {
  agent any
  environment {
        version = "v1.0.0"
        github_org = "navyamiriyala"
        repository = "jenkins"
//         AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
//         AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
//         githubToken = "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"
    }
    stages {
        stage('Checkout') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/main']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: '33e7d5ef-1266-4e01-99d6-cf99c557a1db', url: 'https://github.com/navyamiriyala/jenkins.git']]])
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
        stage('Push Git Tag') {
            steps {
                script {
                    def parts = version.tokenize(".")
                    def major = parts[0].substring(1).toInteger()
                    def minor = parts[1].toInteger()
                    def patch = parts[2].toInteger()
                    def newVersion = "v${major}.${minor}.${patch + env.BUILD_NUMBER}"
                    withCredentials([usernamePassword(credentialsId: "33e7d5ef-1266-4e01-99d6-cf99c557a1db", passwordVariable: "githubPassword", usernameVariable: "githubUsername")]) {
                        sh "git push https://${githubUsername}:${githubPassword}@github.com/navyamiriyala/jenkins.git ${newVersion}"
                    }
                }
            }
        }
//         stage("Create GitHub Release") {
//             steps {
//                 script {
//                     // Retrieve the latest tag from the GitHub repository
//                     def latestTag = sh(returnStdout: true, script: 'git describe --abbrev=0 --tags').trim()
//                     echo "Latest tag: ${latestTag}"
//                     sh "curl -X POST -H 'Authorization: token ${githubToken}' -H 'Content-Type: application/json' -d '{\"tag_name\":\"${latestTag}\",\"target_commitish\": \"main\",\"name\": \"${latestTag}\",\"body\": \"Release created by Jenkins\",\"draft\": false,\"prerelease\": false}' https://api.github.com/repos/${github_org}/${repository}/releases"       
//                 }
//             }
// 	}
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
                withCredentials([string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'),
                       string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')]) {
                    sh 'aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 015838347042.dkr.ecr.us-east-1.amazonaws.com'
//                     sh 'docker build -t my-image .'
                    sh 'docker tag jenkins:latest 015838347042.dkr.ecr.us-east-1.amazonaws.com/jenkins:latest'
                    sh 'docker push 015838347042.dkr.ecr.us-east-1.amazonaws.com/jenkins:latest'
                }
            }
        }
    }
}
