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

        // ✅ NOUVEAU STAGE SONAR
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    bat '''
                    mvn sonar:sonar ^
                      -Dsonar.projectKey=health_app ^
                      -Dsonar.host.url=http://localhost:9000 ^
                      -Dsonar.login=%SONAR_AUTH_TOKEN%
                    '''
                }
            }
        }

        stage('Test') {
            steps {
                bat 'mvn test'
            }
        }

        stage('Docker Cleanup') {
            steps {
                bat 'docker rm -f hapi-fhir-container || echo Aucun conteneur'
            }
        }

        stage('Docker Build & Run') {
            steps {
                bat "docker build -t %DOCKER_IMAGE% ."
                bat "docker run -d --name hapi-fhir-container -p %APP_PORT%:8080 %DOCKER_IMAGE%"
            }
        }
    }

    post {
        always {
            echo 'Pipeline terminé.'
        }
    }
}