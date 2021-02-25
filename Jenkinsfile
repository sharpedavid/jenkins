def DEV_ENVS = ["fireblade.hlth.gov.bc.ca"]
def TEST_ENVS = ["shadow.hlth.gov.bc.ca", "fireblade.hlth.gov.bc.ca"]
pipeline {
    agent any
    tools {
        maven 'Maven'
    }
    parameters {
        string(defaultValue: 'master', description: 'Branch or tag to build. Tags must be specified as "refs/tags/<tagName>".', name: 'BUILD_BRANCH')
        booleanParam(defaultValue: false, description: 'Check box to deploy build.', name: 'DEPLOY')
        choice(choices: ['DEV', 'TEST'], description: 'Deploy to this environment.', name: 'ENVIRONMENT')
        string(name: 'USERNAME')
        password(name: 'PASSWORD')
    }
    stages {
        stage('Checkout') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: "${params.BUILD_BRANCH}"]], userRemoteConfigs: [[url: 'https://github.com/sharpedavid/jenkins']]])
            }
        }
        stage('Build') {
            steps {
                sh 'mvn package'
            }
        }
        stage('Deploy') {
            when {
                expression { params.DEPLOY == true }
            }
            steps {
                script {
                    if (params.ENVIRONMENT == 'DEV') {
                        sshServer = DEV_ENVS
                    } else if (params.ENVIRONMENT == 'TEST') {
                        sshServer = TEST_ENVS
                    }
                    for (int i = 0; i < sshServer.size(); ++i) {
                        def remote = [:]
                        remote.name = sshServer[i]
                        remote.host = sshServer[i]
                        remote.user = params.USERNAME
                        remote.password = params.PASSWORD
                        remote.allowAnyHosts = true
                        remote.pty = true
                        sshPut remote: remote, from: 'target/demo-0.0.1-SNAPSHOT.jar', into: 'demo-0.0.1-SNAPSHOT.jar'
                        sshPut remote: remote, from: "config/${params.ENVIRONMENT}/application.properties", into: 'application.properties'
                        sshPut remote: remote, from: 'script.sh', into: 'script.sh'
                        sshCommand remote: remote, command: 'chmod u+x script.sh; ./script.sh'
                    }
                }
            }
        }
    }
}