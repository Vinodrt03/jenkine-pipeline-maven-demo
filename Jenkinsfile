#!/usr/bin/env groovy

pipeline {
    agent any
    
options {
        buildDiscarder(logRotator(numToKeepStr: '10'))
        disableConcurrentBuilds()
        timeout(time: 1, unit: 'HOURS')
        timestamps()
}
    
    stages {
        stage('Build & Test') {
           steps {
            withMaven(options: [artifactsPublisher(), mavenLinkerPublisher(), dependenciesFingerprintPublisher(disabled: true), jacocoPublisher(disabled: true), junitPublisher(disabled: true)]) {
             sh "mvn -B -U clean package"
            }
           }
        }
     stage('Build Docker Image') {
        steps {
       withCredentials([string(credentialsId: 'AmazonWebServicesCredentialsBindingT', variable: 'AWS_ECR_URL')]) {
    // some block
          script {
           docker.build("${AWS_ECR_URL}:${POM_VERSION}", "--build-arg JAR_FILE=${JAR_NAME} .")
             }
         }
       }
    }
}
}
