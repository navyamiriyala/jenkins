pipeline {
  agent any
  environment {
        version = "v1.0.0"
        github_org = "navyamiriyala"
        repository = "jenkins"
        githubToken = "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"
    }
    stages {
		stage('Checkout') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/main']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'f4fcd66b-8d89-4212-a554-d814019886ed', url: 'https://github.com/navyamiriyala/jenkins.git']]])
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
                    git tag "${newVersion}"
                    def latestTag = sh(returnStdout: true, script: 'git describe --abbrev=0 --tags').trim()
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
                    withCredentials([usernamePassword(credentialsId: "f4fcd66b-8d89-4212-a554-d814019886ed", passwordVariable: "githubPassword", usernameVariable: "githubUsername")]) {
                        git push "https://${githubUsername}:${githubPassword}@github.com/navyamiriyala/jenkins.git" "${newVersion}"
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
                    sh "curl -X POST -H 'Authorization: token ${githubToken}' -H 'Content-Type: application/json' -d '{\"tag_name\":\"${latestTag}\",\"target_commitish\": \"main\",\"name\": \"${latestTag}\",\"body\": \"Release created by Jenkins\",\"draft\": false,\"prerelease\": false}' https://api.github.com/repos/${github_org}/${repository}/releases"           
                }
            }
	}
   }
