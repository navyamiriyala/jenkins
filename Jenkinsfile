pipeline {
    agent any
    environment {
        version = "v4.0.0"
        github_org = "navyamiriyala"
        repository = "jenkins"
	REPOSITORY_URI= "015838347042.dkr.ecr.us-east-1.amazonaws.com/jenkins-test"
    }
    stages {
        stage('Checkout') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/main']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: '90cb8647-93b7-4c21-93c0-a57e62d18756', url: 'https://github.com/navyamiriyala/jenkins.git']]])
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
	stage('Build Docker Image and push to ECR') {
	    steps {
		script {
		    def latestTag = sh(returnStdout: true, script: 'git describe --abbrev=0 --tags || echo "0.0.0"').trim()
		    def TAG = "${latestTag}"
		    sh "docker build -t ${REPOSITORY_URI}:${TAG} ."
	            withCredentials([aws(credentialsId: 'AWS_ACCESS_KEY_ID', region: 'us-east-1')]) {
			sh 'aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 015838347042.dkr.ecr.us-east-1.amazonaws.com'
			sh "docker push ${REPOSITORY_URI}:${TAG}"
		}
	     } 
	  }
       }	
        stage("Update ECS Task Definition") {
            steps {
		script {
		   def latestTag = sh(returnStdout: true, script: 'git describe --abbrev=0 --tags || echo "0.0.0"').trim()
                   withCredentials([aws(credentialsId: 'AWS_ACCESS_KEY_ID', region: 'us-east-1')]) {
		      sh "cd /var/lib/jenkins/workspace/test"
		      sh "sed -i 's|IMAGE_NAME|${REPOSITORY_URI}:${latestTag}|g' task-definition.json"
		      sh "aws ecs register-task-definition --cli-input-json file://task-definition.json --region us-east-1"
                 }
	       }
            }
        }
        stage("Update ECS Service") {
            steps {
                withCredentials([aws(credentialsId: 'AWS_ACCESS_KEY_ID', region: 'us-east-1')]) {
                  sh "aws ecs update-service --cluster inn-dev-cluster-0e6cf42e2321 --service inn-dev-service-0e6cf42e2321 --task-definition inn-dev-td-0e6cf42e2321 --force-new-deployment --region us-east-1"
             }
          }
        }
   }
 }
            
