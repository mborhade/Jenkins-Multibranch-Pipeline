pipeline {
  agent any

  stages {
    stage('Checkout') {
      steps {
        git branch: 'main', url: 'https://github.com/atulkamble/Jenkins-Multibranch-Pipeline.git'
      }
    }

    stage('Build Docker Image') {
      steps {
        sh 'docker build -t my-python-app .'
      }
    }

    stage('Test') {
      steps {
        sh 'docker run --rm my-python-app pytest'
        // or with JUnit output:
        // sh 'docker run --rm -v $PWD:/app my-python-app pytest --junitxml=report.xml'
      }
    }
  }

  // Optional post actions — skip if not generating test reports
  /*
  post {
    always {
      archiveArtifacts artifacts: 'report.xml', allowEmptyArchive: true
      junit 'report.xml'
    }
  }
  */
}
