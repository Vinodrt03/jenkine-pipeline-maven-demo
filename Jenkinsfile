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
         POM_VERSION = getVersion()
         JAR_NAME = getJarName()
         AWS_ECR_REGION = 'ap-south-1'
         AWS_ECS_SERVICE = 'ch-dev-user-api-service'
         AWS_ECS_TASK_DEFINITION = 'ch-dev-user-api-taskdefinition'
         AWS_ECS_COMPATIBILITY = 'FARGATE'
         AWS_ECS_NETWORK_MODE = 'awsvpc'
         AWS_ECS_CPU = '256'
         AWS_ECS_MEMORY = '512'
         AWS_ECS_CLUSTER = 'ch-dev'
         AWS_ECS_TASK_DEFINITION_PATH = './ecs/container-definition-update-image.json'
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
              withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'AWS_REPOSITORY_URL_SECRET']]) {
                 script {
                    docker.build("${AWS_ECR_URL}:${POM_VERSION}", "--build-arg JAR_FILE=${JAR_NAME} .")
                 }
              }
          }
       }
     }
}
             
