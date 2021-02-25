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
        string(defaultValue: 'dasharpe', description: 'TODO', name: 'USERNAME')
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
            steps {
                script {
                    if (params.ENVIRONMENT == 'DEV') {
                        sshServer = DEV_ENVS
                    } else if (params.ENVIRONMENT == 'TEST') {
                        sshServer = TEST_ENVS
                    }
                }
                script {
                    for (int i = 0; i < sshServer.size(); ++i) {
                        def remote = [:]
                        remote.name = sshServer[i]
                        remote.host =  sshServer[i]
                        remote.user = params.USERNAME
                        remote.password = params.PASSWORD
                        remote.allowAnyHosts = true
                        remote.pty = true
                        stage('Remote SSH') {
                            sshPut remote: remote, from: 'target/demo-0.0.1-SNAPSHOT.jar', into: 'demo-0.0.1-SNAPSHOT.jar'
                            sshPut remote: remote, from: "config/${params.ENVIRONMENT}/application.properties", into: 'application.properties'
                            sshCommand remote: remote, command: './script.sh'
                        }
                    }
                }
            }
        }
    }
}