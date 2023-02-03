pipeline {
    agent any
    environment {
        version = "v1.0.0"
        github_org = "navyamiriyala"
        repository = "jenkins"
// 	REPOSITORY_URI= "015838347042.dkr.ecr.us-east-1.amazonaws.com/jenkins"
    }
    stages {
        stage('Checkout') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/main']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: '867e15f7-7bc7-4db0-86b7-fffc593024ac', url: 'https://github.com/navyamiriyala/jenkins.git']]])
            }
        }
        stage('Create Git Tag') {
            steps {
                script {
                    def parts = version.tokenize(".")
                    def major = parts[0].substring(1).toInteger()
                    def minor = parts[1].toInteger()
                    def patch = parts[2].toInteger()
                    def newVersion = "v${major}.${minor}.${patch + BUILD_NUMBER}"
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
                    def newVersion = "v${major}.${minor}.${patch + BUILD_NUMBER}"
                    withCredentials([string(credentialsId: 'github-pat', variable: 'PAT')]) {
  			sh "git push https://${PAT}@github.com/navyamiriyala/jenkins.git ${newVersion}"
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
                    withCredentials([string(credentialsId: 'github-pat', variable: 'PAT')]) {
                    sh "curl -X POST -H 'Authorization: token ${PAT}' -H 'Content-Type: application/json' -d '{\"tag_name\":\"${latestTag}\",\"target_commitish\": \"main\",\"name\": \"${latestTag}\",\"body\": \"Release created by Jenkins\",\"draft\": false,\"prerelease\": false}' https://api.github.com/repos/${github_org}/${repository}/releases"
                    }
                }
            }
        }
	stage('Build Docker Image') {
	    steps {
		  sh 'docker build -t jenkinstest .'
// 		  sh "docker build --tag ${REPOSITORY_URI}:${latestTag} ."
	    }
	}
	stage('Run Docker Image') {
	    steps {
		sh 'docker run jenkinstest'
		sh 'kill $(jobs -p)'
	    }
	} 
	stage('Push to ECR') {
	    steps {
		withCredentials([aws(credentialsId: 'AWS_ACCESS_KEY_ID', region: 'us-east-1')]) {
		    sh 'aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 015838347042.dkr.ecr.us-east-1.amazonaws.com'
// 		    sh 'systemctl start docker'
// 		    sh "docker tag hello-world-python:${latestTag} ${REPOSITORY_URI}:${latestTag}"
	            sh 'docker tag jenkinstest:latest 015838347042.dkr.ecr.us-east-1.amazonaws.com/cicd-deplymt:latest'
                    sh 'docker push 015838347042.dkr.ecr.us-east-1.amazonaws.com/cicd-deplymt:latest'
// 		    sh "docker push ${REPOSITORY_URI}:${latestTag}"
		}
	    }
	}
// 	stage('Deploy to ECS') {
// 	      steps {
// 		withCredentials([aws(credentialsId: 'AWS_ACCESS_KEY_ID', region: 'us-east-1')]) {
// 		  sh 'aws ecs update-service --cluster myCluster --service myService --task-definition myTaskDefinition'
// 		}
// 	      }
// 	    }
    }
}
