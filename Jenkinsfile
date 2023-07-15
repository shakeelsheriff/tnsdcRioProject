pipeline {
    agent any
    environment {
        registry = "************.dkr.ecr.ap-south-1.amazonaws.com/jenkins-pipeline-rio:latest"
    }
    
    stages {
        stage('Initialize') {
            steps {
                script {
                    sh "aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin ************.dkr.ecr.ap-south-1.amazonaws.com" 
                }
            }
        }
        
        stage('Checkout') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/shakeelsheriff/tnsdcRioProject']]])
            }
        }
        
        stage('Build Image') {
            steps {
                sh 'docker build -t rioimage .'
            }
        }
        
        stage('Tag Image') {
            steps {
                script {
                    def imageTag = "1.0" 
                    sh "docker tag rioimage:latest ************.dkr.ecr.ap-south-1.amazonaws.com/jenkins-pipeline-rio:${imageTag}"
                }
            }
        }
        
        stage('Push to ECR') {
            steps {
                script {
                    sh 'aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin ************.dkr.ecr.ap-south-1.amazonaws.com'
                    sh 'docker push ************.dkr.ecr.ap-south-1.amazonaws.com/jenkins-pipeline-rio:1.0'
                }
            }
        }
        
        stage('Deploy with Docker Compose') {
            steps {
                sh 'docker-compose up -d'
            }
        }
    }
}

