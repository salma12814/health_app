pipeline {
    agent any

    tools {
        jdk 'jdk17'
        maven 'maven'
    }

    environment {
        DOCKER_IMAGE = "hapi-fhir:latest"
        APP_PORT = "8085"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'master',
                    url: 'https://github.com/salma12814/health_app.git',
                    credentialsId: 'github-token'
            }
        }

        stage('Build') {
            steps {
                bat 'mvnw.cmd clean package -DskipTests'
            }
        }

        stage('Test') {
            steps {
                bat 'mvnw.cmd test'
            }
        }

        stage('Docker Build & Run') {
            steps {
                bat 'docker build -t %DOCKER_IMAGE% .'
                bat 'docker run -d -p %APP_PORT%:8080 %DOCKER_IMAGE%'
            }
        }

        stage('Health Check') {
            steps {
                bat 'curl -f http://localhost:%APP_PORT%/hapi-fhir-jpaserver/metadata || exit 1'
            }
        }
    }

    post {
        always {
            echo 'Pipeline terminé.'
        }
    }
}