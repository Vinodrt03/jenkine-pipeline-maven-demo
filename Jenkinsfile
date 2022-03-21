#!/usr/bin/env groovy

pipeline {
    agent any
  
  options {
        buildDiscarder(logRotator(numToKeepStr: '10'))
        disableConcurrentBuilds()
        timeout(time: 1, unit: 'HOURS')
        timestamps()
}
 
    stage('Compile stage') {
                steps {
                    maven(maven : 'Maven_3.6.3'){
                        bat "mvn clean compile"
                }
            }
        }

  environment {
        POM_VERSION = getVersion()
        JAR_NAME = getJarName()
        AWS_ECR_REGION = 'ep-south-1'
        AWS_ECS_SERVICE = 'ch-dev-user-api-service'
        AWS_ECS_TASK_DEFINITION = 'ch-dev-user-api-taskdefinition'
        AWS_ECS_COMPATIBILITY = 'FARGATE'
        AWS_ECS_NETWORK_MODE = 'awsvpc'
        AWS_ECS_CPU = '256'
        AWS_ECS_MEMORY = '512'
        AWS_ECS_CLUSTER = 'ch-dev'
        AWS_ECS_TASK_DEFINITION_PATH = './ecs/container-definition-update-image.json'
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
