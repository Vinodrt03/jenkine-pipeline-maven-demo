pipeline {
    agent any
    
    options {
        buildDiscarder(logRotator(numToKeepStr: '10'))
        disableConcurrentBuilds()
        timeout(time: 1, unit: 'HOURS')
        timestamps()
    }
    environment {
      DOCKER_TAG = "getVersion()" 
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
        
    stage('Build Docker Image') {
       steps {
           sh "docker build . -t maven-jar-plugin:3.0.2 "
       }
    }
     stage('Push Image to ECR') {
        steps {
            sh aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin 453304093030.dkr.ecr.ap-south-1.amazonaws.com
            sh docker push 453304093030.dkr.ecr.ap-south-1.amazonaws.com/maven-jar-plugin:3.0.2
        }
     }
     }
}
