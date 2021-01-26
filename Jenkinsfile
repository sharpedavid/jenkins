pipeline {
    agent any
    tools {
        maven 'Maven'
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
                                                        cleanRemote: false,
                                                        excludes: '',
                                                        execCommand: 'nohup /etc/alternatives/jre_11/bin/java demo-0.0.1-SNAPSHOT.jar &',
                                                        execTimeout: 120000,
                                                        flatten: false,
                                                        makeEmptyDirs: false,
                                                        noDefaultExcludes: false,
                                                        patternSeparator: '[, ]+',
                                                        remoteDirectory: '',
                                                        remoteDirectorySDF: false,
                                                        removePrefix: '',
                                                        sourceFiles: 'demo-0.0.1-SNAPSHOT.jar')
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