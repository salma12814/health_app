pipeline {
    agent any

    tools {
        jdk 'jdk17'        // JDK installé dans Jenkins
        maven 'maven'      // Maven installé dans Jenkins
    }

    environment {
        DOCKER_IMAGE = "hapi-fhir:latest"
        APP_PORT = "8085"
    }

    stages {
        stage('Checkout') {
            steps {
                // Branche principale et URL GitHub
                git branch: 'master', 
                    url: 'https://github.com/salma12814/health_app', 
                    credentialsId: 'github-token'  // ton credential Jenkins
            }
        }

        stage('Build') {
            steps {
                bat 'mvnw clean package -DskipTests'
            }
        }

        stage('Test') {
            steps {
                bat 'mvnw test'
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