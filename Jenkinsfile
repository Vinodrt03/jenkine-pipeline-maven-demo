pipeline {
    agent any
     
    tools {
        jdk 'openjdk-11'
        maven 'maven 3.6.3'
        dockerTool 'docker-latest'
} 

stage('Build & Test') {
  steps {
    withMaven(options: [artifactsPublisher(), mavenLinkerPublisher(), dependenciesFingerprintPublisher(disabled: true), jacocoPublisher(disabled: true), junitPublisher(disabled: true)]) {
      sh "mvn -B -U clean package"
    }
  }
} 
}
