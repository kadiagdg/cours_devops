pipeline {
    agent any

    stages {
        stage ("setup_python"){
            steps {
                sh """
                    python3 -m venv jenkinsfile_env
                    . jenkinsfile_env/bin/activate
                    python3 -m pip install --upgrade pip
                    pip install - r requirements.txt
                """

            }
        }
    }
}