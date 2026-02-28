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
                // Cloner le repo GitHub avec ton token
                git branch: 'master', 
                    url: 'https://github.com/salma12814/health_app.git', 
                    credentialsId: 'github-token'
            }
        }

        stage('Build') {
            steps {
                sh './mvnw clean package -DskipTests'
            }
        }

        stage('Test') {
            steps {
                sh './mvnw test'
            }
        }

        stage('Docker Build & Run') {
            steps {
                sh "docker build -t ${DOCKER_IMAGE} ."
                sh "docker run -d -p ${APP_PORT}:8080 ${DOCKER_IMAGE}"
            }
        }

        stage('Health Check') {
            steps {
                sh "curl -f http://localhost:${APP_PORT}/hapi-fhir-jpaserver/metadata || exit 1"
            }
        }
    }

    post {
        always {
            echo 'Pipeline terminé.'
        }
    }
}