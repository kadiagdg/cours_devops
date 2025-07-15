pipeline {
    agent any

    environment {
        HARBOR_USERNAME = credentials('harbor-username-fadel') // Jenkins credential ID
        HARBOR_TOKEN = credentials('harbor-token-fadel')       // Jenkins credential ID
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
                sh 'pytest'
                sh 'pytest --cov=. --cov-report=term'
            }
        }

        stage('Build and Push Docker Image') {
            /*when {
                expression {
                    return env.CHANGE_ID == null // Skip for pull requests
                }
            }*/
            steps {
                script {
                    sh 'docker build -t harbor.devgauss.com/fadel/fastapi-postgres:${env.BUILD_ID} .'
                    sh 'echo $HARBOR_TOKEN | docker login -u $HARBOR_USERNAME --password-stdin'
                    sh 'docker push harbor.devgauss.com/fadel/fastapi-postgres:${env.BUILD_ID}'
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