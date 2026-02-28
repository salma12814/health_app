pipeline {
    agent any

    tools {
        jdk 'jdk17'        // le JDK installé dans Jenkins
        maven 'maven'      // Maven installé dans Jenkins
    }

    environment {
        DOCKER_IMAGE = "hapi-fhir:latest"
        APP_PORT = "8085"
    }

    stages {
        stage('Checkout') {
            steps {
                // Remplace 'master' par ta branche principale si ce n'est pas 'master'
                git branch: 'master', url: 'https://github.com/TON_USERNAME/hapi-fhir-jpaserver-starter.git'
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