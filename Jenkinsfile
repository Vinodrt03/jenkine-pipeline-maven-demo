pipeline {
    agent any
    
    options {
        buildDiscarder(logRotator(numToKeepStr: '10'))
        disableConcurrentBuilds()
        timeout(time: 1, unit: 'HOURS')
        timestamps()
    }
    environment {
        AWS_ACCOUNT_ID="453304093030"
        AWS_DEFAULT_REGION="ap-south-1"
        IMAGE_REPO_NAME="java-project"
        IMAGE_TAG="v1"
        REPOSITORY_URI = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}"
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
              script {
                dockerImage = docker.build "${IMAGE_REPO_NAME}:${IMAGE_TAG}"
              }
          }
       }
       stage('Pushing to ECR') {
         steps{  
             script {
                sh "docker tag ${IMAGE_REPO_NAME}:${IMAGE_TAG} ${REPOSITORY_URI}:$IMAGE_TAG"
                sh "docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}:${IMAGE_TAG}"
             }
         }
       }
     }
}
      
