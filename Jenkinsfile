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
    }
