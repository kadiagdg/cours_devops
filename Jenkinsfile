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
                    pytest \
                        --cov=. \
                        --cov-report=xml:coverage.xml \
                        --cov-report=html:htmlcov \
                        --cov-report=term \
                        --cov-fail-under=80 \
                        --junitxml=test-results.xml
                """
            }
        }
    }
}