pipeline {
    agent any
    
    options {
        buildDiscarder(logRotator(numToKeepStr: '10'))
        disableConcurrentBuilds()
        timeout(time: 1, unit: 'HOURS')
        timestamps
    }
    tools {
        maven 'maven'
        dockerTool 'docker'
        jdk 'JDK'
    }
     stages {
        stage('Build & Test') {
        steps {
         withMaven(options: [artifactsPublisher(), mavenLinkerPublisher(), dependenciesFingerprintPublisher(disabled: true), jacocoPublisher(disabled: true), junitPublisher(disabled: true)]) {
          sh "mvn -B -U clean package"
         }
        }
        }
     }
}
