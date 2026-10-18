pipeline {

    agent any

    environment {
        IMAGE_NAME = "buildhouse/project_02"
        REGISTRY_CREDENTIALS = credentials('dockerhub-credentials')
        IMAGE_TAG = "${1}"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                sh """
                    docker build \
                    -t ${buildhouse/project_02}:${v1} \
                    -t ${buildhouse/project_02}:latest .
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

