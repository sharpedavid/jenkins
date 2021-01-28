def DEV_ENVS = ["Fireblade"]
def TEST_ENVS = ["Shadow", "Fireblade"]
pipeline {
    agent any
    tools {
        maven 'Maven'
    }
    parameters {
        string(defaultValue: 'master', description: 'Branch or tag to build. Tags must be specified as "refs/tags/<tagName>".', name: 'BUILD_BRANCH')
        booleanParam(defaultValue: false, description: 'Check box to deploy build.', name: 'DEPLOY')
        choice(choices: ['DEV', 'TEST'], description: 'Deploy to this environment.', name: 'ENVIRONMENT')
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
                }
                script {
                    for (int i = 0; i < sshServer.size(); ++i) {
                        sshPublisher(
                                continueOnError: false,
                                failOnError: true,
                                publishers: [
                                        sshPublisherDesc(
                                                configName: "${sshServer[i]}",
                                                transfers: [
                                                        sshTransfer(
                                                                execCommand: 'nohup /etc/alternatives/jre_11/bin/java -jar demo-0.0.1-SNAPSHOT.jar > nohup.out &',
                                                                removePrefix: 'target',
                                                                sourceFiles: 'target/demo-0.0.1-SNAPSHOT.jar'),
                                                        sshTransfer(
                                                                flatten: true,
                                                                sourceFiles: "config/${params.ENVIRONMENT}/application.properties")
                                                ],
                                                usePromotionTimestamp: false,
                                                useWorkspaceInPromotion: false,
                                                verbose: false)
                                ]
                        )
                    }

                }
            }
        }
    }
}