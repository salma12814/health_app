pipeline {
    agent any

    tools {
        jdk 'jdk17'
        maven 'maven'
    }

    environment {
        DOCKER_IMAGE = "hapi-fhir:latest"
        APP_PORT = "8085"
        CONTAINER_NAME = "hapi-fhir-container"
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

        // 🚀 Stage Docker Cleanup amélioré
        stage('Docker Cleanup') {
            steps {
                bat """
                REM Stop et remove le conteneur s'il existe
                for /f %%i in ('docker ps -aqf "name=%CONTAINER_NAME%"') do docker rm -f %%i
                """
            }
        }

        stage('Docker Build & Run') {
            steps {
                bat "docker build -t %DOCKER_IMAGE% ."
                bat "docker run -d --name %CONTAINER_NAME% -p %APP_PORT%:8080 %DOCKER_IMAGE%"
            }
        }
    }

    post {
        always {
            echo 'Pipeline terminé.'
        }
    }
}