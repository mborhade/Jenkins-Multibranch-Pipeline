# Jenkins with a Docker-based Python application
# Jenkins-Multibranch-Pipeline

```
git clone https://github.com/atulkamble/Jenkins-Multibranch-Pipeline.git
cd Jenkins-Multibranch-Pipeline
```

To create a multibranch pipeline using Docker in a Python project, you'll typically use a CI/CD tool like Jenkins, GitLab CI, or GitHub Actions. 
Using Jenkins with a Docker-based Python application.

1. Launch and connect SG on EC2:
2. Set Security Group for Inbound Traffic
Jenkins: 8080
flask: 5000

# Prereqiuisites
Git, Python, Flask, Docker, Jenkins
```
sudo yum install pip -y
pip --version
sudo pip install flask -y
flask --version
```
// Update your dockerhub username in deploy.sh
example: atuljkamble

// Manual & Test/Run Code
```
python app.py
or
python3 app.py
```

// Run Script
```
sudo sh deploy.sh
```
// deployment will be at URL
```
https://hub.docker.com/r/atuljkamble/my-python-app
```

// list docker images
```
sudo docker images
```


### Jenkinsfile Example

This Jenkinsfile demonstrates how to set up a multibranch pipeline with Docker for a Python project:

```groovy
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
                    docker.image('my-python-app').inside {
                        sh 'pytest'
                    }
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
```

### Key Points:
1. **Environment**: Sets the base Docker image for Python.
2. **Checkout**: Pulls the latest code from the SCM (e.g., Git).
3. **Build Docker Image**: Creates a Docker image for your Python application.
4. **Test**: Runs tests inside the Docker container.
5. **Deploy**: Deploys the application only if the branch is `main`.
6. **Post Actions**: Archives test results and generates reports.

### Dockerfile Example

You’ll need a `Dockerfile` for building the Docker image. Here’s a basic example for a Python application:

```dockerfile
# Use an official Python runtime as a parent image
FROM python:3.9

# Set the working directory in the container
WORKDIR /app

# Copy the requirements file into the container
COPY requirements.txt .

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code into the container
COPY . .

# Run the application
CMD ["python", "app.py"]
```

Here’s a basic `deploy.sh` script that you can use for deploying your Dockerized Python application. This script assumes you want to deploy your Docker container to a server or cloud platform and might also include steps to push the Docker image to a container registry.

### `deploy.sh`

```bash
#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Variables
IMAGE_NAME="my-python-app"
IMAGE_TAG="latest"
REGISTRY_URL="atuljkamble"  # Replace with your Docker registry URL if needed

# Build the Docker image (optional, if not already built)
echo "Building Docker image..."
docker build -t $IMAGE_NAME:$IMAGE_TAG .

# Tag and push the Docker image to a registry (optional, if using a registry)
echo "Tagging and pushing Docker image..."
docker tag $IMAGE_NAME:$IMAGE_TAG $REGISTRY_URL/$IMAGE_NAME:$IMAGE_TAG
docker push $REGISTRY_URL/$IMAGE_NAME:$IMAGE_TAG

# Pull the Docker image on the deployment server
echo "Pulling Docker image on the deployment server..."
docker pull $REGISTRY_URL/$IMAGE_NAME:$IMAGE_TAG

# Stop and remove existing container if it exists
echo "Stopping and removing existing container if any..."
docker stop $IMAGE_NAME || true && docker rm $IMAGE_NAME || true

# Run the new container
echo "Running new Docker container..."
docker run -d --name $IMAGE_NAME -p 80:5000 $REGISTRY_URL/$IMAGE_NAME:$IMAGE_TAG

echo "Deployment complete!"
```

### Explanation:

1. **Set Exit on Error**: Ensures the script exits if any command fails.
2. **Variables**: Define the Docker image name, tag, and registry URL.
3. **Build Docker Image**: (Optional) Builds the Docker image locally. If you’ve already built the image in the Jenkins pipeline, you can skip this step.
4. **Tag and Push Docker Image**: (Optional) Tags and pushes the Docker image to a container registry. Replace `your-docker-registry-url` with your actual Docker registry URL.
5. **Pull Docker Image**: Pulls the Docker image on the deployment server.
6. **Stop and Remove Existing Container**: Stops and removes any existing container with the same name.
7. **Run New Container**: Runs the new Docker container on the deployment server, exposing port 80 to port 5000 of the container. Adjust ports as needed.

### Additional Notes:

- **SSH Access**: Ensure you have SSH access to your deployment server and that the `ssh` command is properly configured.
- **Ports**: Adjust the port mappings as necessary for your application.
- **Docker Registry**: If you’re using a private Docker registry, ensure proper authentication and access.

This script provides a basic framework; you might need to adjust it based on your specific deployment environment and requirements.

- **Jenkins Multibranch Pipeline**: This setup allows Jenkins to automatically create a pipeline for each branch in your repository.
- **Docker Integration**: The `docker.image(...).inside` block runs commands inside the Docker container.
- **Deployment Script**: Make sure to include a `deploy.sh` script or replace it with your deployment commands.

### Delete Docker Image and containers
// delete all docker images 
```
sudo docker image prune -a
```

// list and delete specific docker image
```
sudo docker images
sudo docker rmi acdc90ce6a0e -f
```

// list containers
```
sudo docker container ls
sudo docker container stop bf95edad9bb7
sudo docker container rm bf95edad9bb7
```

You can adapt this setup to other CI/CD tools by translating the concepts to their respective configurations.
