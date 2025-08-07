pipeline {
    agent any

    stages {
        stage ("setup_python"){
            steps {
                sh """
                    python3 -m venv jenkinsfile_env
                    . jenkinsfile_env/bin/activate
                    python3 -m pip install --upgrade pip
                    pip install -r requirements.txt
                """

            }
        }
        stage("run_test"){
            steps{
                sh """
                    # Run tests with coverage reporting
                    . jenkinsfile_env/bin/activate
                    pytest \
                        --cov=. \
                        --cov-report=xml:coverage.xml \
                        --cov-report=html:htmlcov \
                        --cov-report=term \
                        --cov-fail-under=80 \
                        --junitxml=test-results.xml
                """
            }

            post {
                always {
                    // Archive test artifacts and coverage reports
                    archiveArtifacts artifacts: 'coverage.xml,htmlcov/**/*,test-results.xml', allowEmptyArchive: true

                    // Publish JUnit test results
                    junit 'test-results.xml'

                    // Publish HTML coverage report
                    publishHTML(target: [
                        allowMissing: false,
                        alwaysLinkToLastBuild: true,
                        keepAll: true,
                        reportDir: 'htmlcov',
                        reportFiles: 'index.html',
                        reportName: 'Coverage Report'
                    ])
                }
            }
        }
        stage("sonarqube analysis"){
            steps{
                withSonarQubeEnv("sonarqube_essan"){
                    script {
                        def scannerHome = tool "SonarScanner" 
                        sh """ 
                            ${scannerHome}/bin/sonar-scanner
                        """
                    }
                }

            }
        }
        

    }
}