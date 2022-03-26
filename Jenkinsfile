#!/usr/bin/env groovy

pipeline {
    agent any
 
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
          withCredentials([string(credentialsId: '453304093030.dkr.ecr.ap-south-1.amazonaws.com/java-project', variable: 'AWS_ECR_URL')]) {
           script {
            docker.build("${AWS_ECR_URL}:${POM_VERSION}", "--build-arg JAR_FILE=${JAR_NAME} .")
      }
    }
  }
    }
}
}
