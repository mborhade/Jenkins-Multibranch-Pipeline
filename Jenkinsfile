pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t my-python-app .'
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    // Run tests inside the container and generate JUnit XML
                    sh '''
                    docker run --rm -v "$PWD:/app" my-python-app \
                    pytest --junitxml=/app/test-results/results.xml --disable-warnings || true
                    '''
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    // Check if image exists before deploy
                    sh 'docker inspect -f . my-python-app'

                    // Run deploy script directly on host
                    sh 'chmod +x deploy.sh && ./deploy.sh'
                }
            }
        }
    }

    post {
        always {
            // Archive test results if exists
            script {
                if (fileExists('test-results/results.xml')) {
                    junit 'test-results/results.xml'
                } else {
                    echo "No test results found to archive."
                }
            }

            archiveArtifacts artifacts: '**/test-results/*.xml', allowEmptyArchive: true
        }
    }
}
