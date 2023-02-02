pipeline {
  agent any
  environment {
        version = "v1.0.0"
        github_org = "navyamiriyala"
        repository = "jenkins"
//         githubToken = "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"
    }
    stages {
        stage('Checkout') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/main']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'a11c912d-fdd7-4de2-906c-5878fafd6b62', url: 'https://github.com/navyamiriyala/jenkins.git']]])
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
                    withCredentials([usernamePassword(credentialsId: "a11c912d-fdd7-4de2-906c-5878fafd6b62", passwordVariable: "githubPassword", usernameVariable: "githubUsername")]) {
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
//                     sh "curl -X POST -H 'Authorization: token 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' -H 'Content-Type: application/json' -d '{\"tag_name\":\"${latestTag}\",\"target_commitish\": \"main\",\"name\": \"${latestTag}\",\"body\": \"Release created by Jenkins\",\"draft\": false,\"prerelease\": false}' https://api.github.com/repos/${github_org}/${repository}/releases"       
//                 }
//             }
// 	}
    }
}
