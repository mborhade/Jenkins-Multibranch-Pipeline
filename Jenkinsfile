pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'python:3.9'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build('my-python-app')
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    sh "pip install pytest" // Ensure pytest is installed
                    sh "mkdir -p test-results" // Ensure the results directory exists
                    sh "python -m pytest tests --junitxml=test-results/results.xml --disable-warnings" // Run tests with proper output
                }
            }
        }

        stage('Deploy') {
            when {
                branch 'main'
            }
            steps {
                script {
                    docker.image('my-python-app').inside {
                        sh 'chmod +x deploy.sh && ./deploy.sh' // Ensure deploy script is executable
                    }
                }
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'test-results/results.xml', allowEmptyArchive: true
            junit 'test-results/results.xml'
        }
    }
}
