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
                    sh '''
                    docker run --rm -v "$PWD:/app" my-python-app \
                    pytest --junitxml=/app/test-results/results.xml --disable-warnings || true
                    '''
                }
            }
        }

        stage('Deploy') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'atuljkamble', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                    script {
                        // Check image exists
                        sh 'docker inspect -f . my-python-app'

                        // Run deploy script
                        sh 'chmod +x deploy.sh && ./deploy.sh'
                    }
                }
            }
        }
    }

    post {
        always {
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
