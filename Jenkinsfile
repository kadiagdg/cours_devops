pipeline {
    agent any

    environment {
        PROJECT = "fadel" // à modifier avec votre projet
        REPOSITORY = "fastapi-postgres"
        IMAGE = "$PROJECT/$REPOSITORY"
        REGISTRY_HOST = "https://harbor.devgauss.com"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Set up Python') {
            /*agent {
                docker {
                    image 'python:3.13'
                }
            }*/
            steps {
                sh '''
                    python3 -m venv venv
                    . venv/bin/activate
                    python3 -m pip install --upgrade pip
                    pip install -r requirements.txt
                '''
            }
        }

        stage('Run Tests') {
            /*agent {
                docker {
                    image 'python:3.13'
                }
            }*/
            steps {
                sh '''
                    . venv/bin/activate
                    pytest
                    pytest --cov=. --cov-report=term
                '''
            }
        }

        stage('Build and Push Docker Image') {
            when {
                expression {
                    return env.CHANGE_ID == null // Skip for pull requests
                }
            }
            steps {
                script {
                    def image = docker.build("$IMAGE:${env.BUILD_ID}")
                    docker.withRegistry("$REGISTRY_HOST", 'registry-credentials-fadel') {
                        image.push()
                        image.push('latest')
                    }
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}

/*z5WQHoxUsDTh3saibDbaS7Ug0EZbToIk*/

/*TODO */
/* Plugins to block pipeline triggers*/