pipeline {

    agent any

    environment {

        AWS_REGION = "ap-southeast-1"

        ECR_REPO = "devops-project-dev-backend"

        ACCOUNT_ID = "274118253913"

        IMAGE_TAG = "${BUILD_NUMBER}"

    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'dev',
                url: 'https://github.com/NhutKhanh24520782/devops-cicd-aws.git'
            }
        }

        stage('Build Docker') {

            steps {

                dir('app/backend') {

                    sh """
                    docker build -t ${ECR_REPO}:${IMAGE_TAG} .
                    """

                }

            }

        }

        stage('Login ECR') {

            steps {

                sh """
                aws ecr get-login-password --region ${AWS_REGION} \
                | docker login \
                --username AWS \
                --password-stdin \
                ${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
                """

            }

        }

        stage('Push') {

            steps {

                sh """

                docker tag ${ECR_REPO}:${IMAGE_TAG} \
                ${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}:${IMAGE_TAG}

                docker push \
                ${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}:${IMAGE_TAG}

                """

            }

        }

        stage('Deploy') {

            steps {

                sh """

                kubectl set image deployment/backend \
                backend=${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}:${IMAGE_TAG} \
                -n devops-project

                """

            }

        }

    }

}