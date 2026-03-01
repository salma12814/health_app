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
                    url: 'https://github.com/salma12814/health_app', 
                    credentialsId: 'github-token'
            }
        }

        stage('Build') {
            steps {
                bat 'mvn clean package -DskipTests'
            }
        }

        stage('Test') {
            steps {
                bat 'mvn test'
            }
        }

        stage('Docker Build & Run') {
            steps {
                bat "docker build -t %DOCKER_IMAGE% ."
                bat "docker run -d -p %APP_PORT%:8080 %DOCKER_IMAGE%"
            }
        }
    } // <-- fermeture correcte du bloc stages

    post {
        always {
            echo 'Pipeline terminé.'
        }
    }
}