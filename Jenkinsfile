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
                echo "Chosen environment is ${params.ENVIRONMENT}"
                sh 'mvn package'
            }
        }
        stage('Hello') {
            steps {
                sshPublisher(
                        continueOnError: false,
                        failOnError: true,
                        publishers: [
                                sshPublisherDesc(
                                        configName: 'Fireblade',
                                        transfers: [
                                                sshTransfer(
                                                        execCommand: 'nohup /etc/alternatives/jre_11/bin/java -jar demo-0.0.1-SNAPSHOT.jar > nohup.out &',
                                                        removePrefix: 'target',
                                                        sourceFiles: 'target/demo-0.0.1-SNAPSHOT.jar'),
                                                sshTransfer(
                                                        flatten: true,
                                                        sourceFiles: 'config/DEV/application.properties')
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