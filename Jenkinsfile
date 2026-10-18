pipeline {

    agent any

    environment {
        IMAGE_NAME = "buildhouse/project_02"
        REGISTRY_CREDENTIALS = credentials('dockerhub-credentials')
        IMAGE_TAG = "${BUILD_NUMBER}"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Check Workspace') {
    steps {
        sh '''
            echo "Current directory:"
            pwd

            echo "Files downloaded from GitHub:"
            ls -la

            echo "Dockerfiles:"
            find . -maxdepth 4 -iname 'Dockerfile' -type f
        '''
    }
}

        stage('Build Docker Image') {
            steps {
                sh """
                    docker build \
                    -t ${IMAGE_NAME}:${IMAGE_TAG} \
                -t ${IMAGE_NAME}:latest .
                """
            }
        }

        stage('Docker Login') {
            steps {
                sh '''
                    echo "$REGISTRY_CREDENTIALS_PSW" | \
                    docker login -u "$REGISTRY_CREDENTIALS_USR" \
                    --password-stdin
                '''
            }
        }

        stage('Push Docker Image') {
    steps {
        withCredentials([usernamePassword(
            credentialsId: 'dockerhub-credentials',
            usernameVariable: 'DOCKERHUB_USER',
            passwordVariable: 'DOCKERHUB_TOKEN'
        )]) {
            sh '''
                set +x
                echo "$DOCKERHUB_TOKEN" | docker login \
                    --username "$DOCKERHUB_USER" \
                    --password-stdin

                docker push "$IMAGE_NAME:$IMAGE_TAG"
                docker push "$IMAGE_NAME:latest"

                docker logout
            '''
        }
    }
}
        stage('Deploy') {
            steps {
                echo "Deployment stage"
                
        sshagent(['production-ec2-ssh']) {
            sh '''
                ssh -o StrictHostKeyChecking=yes \
                    ubuntu@3.6.40.49\
                    "sudo docker pull buildhouse/project_02:v1"
            '''
        }
    }
}

            }

        
}

    post {

        success {
            echo 'Pipeline completed successfully.'
        }

        failure {
            echo 'Pipeline failed.'
        }
    }

