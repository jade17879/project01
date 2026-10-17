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

        stage('Push Image') {
            steps {
                sh """
                    docker push buildhouse/project_02:v1
                    docker push ${buildhouse/project_02}:latest
                """
            }
        }

        stage('Deploy') {
            steps {
                echo "Deployment stage"
                
stage('Deploy to EC2') {
    steps {
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

        stage('Test EC2 SSH') {
    steps {
        sshagent(['production-ec2-ssh']) {
            sh '''
                ssh -o StrictHostKeyChecking=yes \
                    ubuntu@3.6.40.49 \
                    "hostname"
            '''
        }
    }
}

        stage('Health Check') {
            steps {
                echo "Health check stage"
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
}
