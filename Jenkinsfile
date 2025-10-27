pipeline {
    agent any

    environment {
        DOCKER_HUB_REPO = 'dhruv152005/testapp'
        IMAGE_TAG = "${BUILD_NUMBER}"
    }

    stages {
        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image...'
                sh 'docker build -t $DOCKER_HUB_REPO:$IMAGE_TAG .'
            }
        }

        stage('Login to Docker Hub') {
            steps {
                echo 'Logging into Docker Hub...'
                withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                }
            }
        }

        stage('Push Image to Docker Hub') {
            steps {
                echo 'Pushing image to Docker Hub...'
                sh 'docker push $DOCKER_HUB_REPO:$IMAGE_TAG'
                sh 'docker tag $DOCKER_HUB_REPO:$IMAGE_TAG $DOCKER_HUB_REPO:latest'
                sh 'docker push $DOCKER_HUB_REPO:latest'
            }
        }

        stage('Cleanup') {
            steps {
                echo 'Cleaning up...'
                sh 'docker rmi $DOCKER_HUB_REPO:$IMAGE_TAG || true'
                sh 'docker logout'
            }
        }
    }

    post {
        success {
            echo "✅ Image successfully pushed to Docker Hub: $DOCKER_HUB_REPO:$IMAGE_TAG"
        }
        failure {
            echo "❌ Build failed!"
        }
    }
}
