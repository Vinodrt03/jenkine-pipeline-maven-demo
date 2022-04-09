pipeline {
    agent any
    
    options {
        buildDiscarder(logRotator(numToKeepStr: '10'))
        disableConcurrentBuilds()
        timeout(time: 1, unit: 'HOURS')
        timestamps()
    }
    environment {
         AWS_ECR_URL = "453304093030.dkr.ecr.ap-south-1.amazonaws.com/java-project"
         AWS_ACCOUNT_ID="453304093030"
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
              withAWS(roleAccount:'$AWS_REPOSITORY_URL_SECRET', role:'AWS_REPOSITORY_URL_SECRET', variable: '$AWS_ECR_URL')]) {
                 script {
                    docker.build("${AWS_ECR_URL}:${POM_VERSION}", "--build-arg JAR_FILE=${JAR_NAME} .")
                 }
              }
          }
       }
     }
}
             
