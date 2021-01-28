def DEV_ENVS = ["Fireblade"]
def TEST_ENVS = ["Shadow", "Fireblade"]
pipeline {
    agent any
    tools {
        maven 'Maven'
    }
    parameters {
        choice(choices: ['DEV', 'TEST'], description: '', name: 'ENVIRONMENT')
        string(defaultValue: 'master', description: '', name: 'BUILD_BRANCH')
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: "${params.BUILD_BRANCH}", url: 'https://github.com/sharpedavid/jenkins'
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