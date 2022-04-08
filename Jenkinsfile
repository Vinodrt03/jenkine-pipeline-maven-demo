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
        tag = sh(returnStdout: true, script: "git rev-parse --short=10 HEAD").trim()`
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
                dockerImage = docker.build "${IMAGE_REPO_NAME}:${tag}"
              }
          }
       }
       stage('Pushing to ECR') {
         steps{  
             script {
                sh 'aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin 453304093030.dkr.ecr.ap-south-1.amazonaws.com' 
                sh "docker tag ${IMAGE_REPO_NAME}:${IMAGE_TAG} ${REPOSITORY_URI}:$IMAGE_TAG"
                sh "docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}:${tag}"
             }
         }
       }
     }
}
      
