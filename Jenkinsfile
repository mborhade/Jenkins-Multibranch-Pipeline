pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'my-python-app'
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
                    docker.build(env.DOCKER_IMAGE)
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    // Run tests inside a container based on the built image
                    sh "docker run --rm -v \$PWD:/app ${DOCKER_IMAGE} pytest --junitxml=/app/test-results/results.xml --disable-warnings || true"
                }
            }
        }

        stage('Deploy') {
            when {
                branch 'main'
            }
            steps {
                script {
                    docker.image(env.DOCKER_IMAGE).inside {
                        sh 'chmod +x deploy.sh && ./deploy.sh'
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
