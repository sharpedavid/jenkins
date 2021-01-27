pipeline {
    agent any
    tools {
        maven 'Maven'
    }
    parameters {
        choice(choices: ['DEV', 'TEST'], description: '', name: 'ENVIRONMENT')
    }
    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/sharpedavid/jenkins'
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
                        sshServer = "Fireblade"
                    } else if (params.ENVIRONMENT == 'TEST') {
                        sshServer = "Shadow"
                    }
                }
                sshPublisher(
                        continueOnError: false,
                        failOnError: true,
                        publishers: [
                                sshPublisherDesc(
                                        configName: "${sshServer}",
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