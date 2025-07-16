pipeline {
    agent any

    environment {
        PROJECT = "fadel" // à modifier avec votre projet
        REPOSITORY = "fastapi-postgres"
        IMAGE = "$PROJECT/$REPOSITORY"
        REGISTRY_HOST = "https://harbor.devgauss.com"
    }

    parameters {
        choice(
            name: 'ENVIRONMENT',
            choices: ['development', 'staging', 'production'],
            description: 'Target environment'
        )
        booleanParam(
            name: 'SKIP_TESTS',
            defaultValue: false,
            description: 'Skip test execution'
        )
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Set up Python') {
            steps {
                sh '''
                    python3 -m venv venv
                    . venv/bin/activate
                    python3 -m pip install --upgrade pip
                    pip install -r requirements.txt
                '''
            }
        }

        /*
        stage('Code Quality Checks') {
            parallel {
                stage('Lint') {
                    steps {
                        sh '''
                            . venv/bin/activate
                            pip install flake8 black isort

                            # Run linting
                            flake8 . --count --select=E9,F63,F7,F82 --show-source --statistics

                            # Check code formatting
                            black --check .

                            # Check import sorting
                            isort --check-only .
                        '''
                    }
                }

                stage('Security Scan') {
                    steps {
                        sh '''
                            . venv/bin/activate
                            pip install bandit safety

                            # Run security checks
                            bandit -r . -x tests/

                            # Check for known vulnerabilities
                            safety check
                        '''
                    }
                }
            }
        }
        */

        stage('Run Tests') {
            when {
                expression { return !params.SKIP_TESTS }
            }
            steps {
                sh '''
                    . venv/bin/activate
                    pytest
                    pytest \
                        --cov=. \
                        --cov-report=xml:coverage.xml \
                        --cov-report=html:htmlcov \
                        --cov-report=term \
                        --junitxml=test-results.xml
                '''
            }
            post {
                always {
                    // Publish test results
                    junit 'test-results.xml'

                    // Publish coverage report
                    publishCoverage adapters: [
                        coberturaAdapter(path: 'coverage.xml')
                    ], sourceFileResolver: sourceFiles('STORE_LAST_BUILD')

                    // Archive test artifacts
                    archiveArtifacts artifacts: 'test-report.html,htmlcov/**/*', allowEmptyArchive: true
                }
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
                    docker.withRegistry("$REGISTRY_HOST", 'registry-credentials-fadel') { // Créez un credentials de type Username Password avec les accès de votre compte robot Harbor
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
        success {
            echo 'Pipeline succeeded!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}

/*z5WQHoxUsDTh3saibDbaS7Ug0EZbToIk*/

/*TODO */
/* Plugins to block pipeline triggers*/