pipeline {
    agent any

    environment {
        DOCKER_HUB_REPO = 'hydrajoule/myapp'
        IMAGE_TAG = "${BUILD_NUMBER}"
    }

    stages {
        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image...'
                bat "docker build -t %DOCKER_HUB_REPO%:%IMAGE_TAG% ."
            }
        }

        stage('Login to Docker Hub') {
            steps {
                echo 'Logging into Docker Hub...'
                withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    // Windows batch syntax for piping password into docker login
                    bat 'echo %DOCKER_PASS% | docker login -u %DOCKER_USER% --password-stdin'
                }
            }
        }

        stage('Push Image to Docker Hub') {
            steps {
                echo 'Pushing image to Docker Hub...'
                bat "docker push %DOCKER_HUB_REPO%:%IMAGE_TAG%"
                bat "docker tag %DOCKER_HUB_REPO%:%IMAGE_TAG% %DOCKER_HUB_REPO%:latest"
                bat "docker push %DOCKER_HUB_REPO%:latest"
            }
        }

        stage('Cleanup') {
            steps {
                echo 'Cleaning up...'
                bat "docker rmi %DOCKER_HUB_REPO%:%IMAGE_TAG% || exit 0"
                bat "docker logout"
            }
        }
    }

    post {
        success {
            echo "✅ Image successfully pushed to Docker Hub: ${env.DOCKER_HUB_REPO}:${env.IMAGE_TAG}"
        }
        failure {
            echo "❌ Build failed!"
        }
    }
}
