pipeline {

    agent any

    environment {

        AWS_REGION = "ap-southeast-1"

        ECR_REPO = "devops-project-dev-backend"

        ACCOUNT_ID = "274118253913"

        // Git SHA (7 chars) — deterministic, traceable, survives Jenkins reinstall.
        // Example tag: abc1234
        IMAGE_TAG = sh(script: 'git rev-parse --short=7 HEAD', returnStdout: true).trim()

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

        stage('Verify') {

            steps {

                // Block until rollout completes (or fail after 2 min).
                // Ensures Jenkins reports FAILURE if pods don't become Ready.
                sh "kubectl rollout status deployment/backend -n devops-project --timeout=120s"

            }

        }

    }

}