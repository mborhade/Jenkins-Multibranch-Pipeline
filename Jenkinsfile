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
            sh "python -m pytest --junitxml=results.xml" // Run pytest and generate a JUnit report
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
                        sh './deploy.sh'
                    }
                }
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: '**/test-results/*.xml', allowEmptyArchive: true
            junit '**/test-results/*.xml'
        }
    }
}
