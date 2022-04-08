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
      AWS_ECR_URL = "453304093030.dkr.ecr.ap-south-1.amazonaws.com/java-project"  
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
           withCredentials([string(credentialsId: 'AWS_REPOSITORY_URL_SECRET', variable: 'AWS_ECR_URL')]) {
              script {
                docker.build("${AWS_ECR_URL}:${POM_VERSION}", "--build-arg JAR_FILE=${JAR_NAME} .")
              }
           }
        }
    }
     }
}
