#!/bin/bash

# Exit immediately if any command fails
set -e

# Variables
IMAGE_NAME="my-python-app"
IMAGE_TAG="latest"
REGISTRY_URL="atuljkamble"

echo "Logging into Docker..."
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin

echo "Cleaning up Docker cache..."
docker image prune -af || true

echo "Building Docker image..."
docker build -t $IMAGE_NAME:$IMAGE_TAG .

echo "Tagging and pushing Docker image..."
docker tag $IMAGE_NAME:$IMAGE_TAG $REGISTRY_URL/$IMAGE_NAME:$IMAGE_TAG
docker push $REGISTRY_URL/$IMAGE_NAME:$IMAGE_TAG

echo "Stopping and removing existing container if running..."
docker stop $IMAGE_NAME 2>/dev/null || true
docker rm $IMAGE_NAME 2>/dev/null || true

echo "Running new container..."
docker run -d --name $IMAGE_NAME -p 5000:5000 --restart always $REGISTRY_URL/$IMAGE_NAME:$IMAGE_TAG

echo "Deployment complete!"
