#!/bin/bash

set -e

IMAGE="buildhouse/kanban-dashboard:v1"

echo "Pulling image..."
docker pull "$IMAGE"

echo "Stopping old container..."
docker stop kanban-dashboard || true

echo "Removing old container..."
docker rm kanban-dashboard || true

echo "Starting new container..."

docker run -d \
    --name kanban-dashboard \
    --restart unless-stopped \
    --memory=512m \
    --cpus=1 \
    -p 80:80 \
    "$IMAGE"

echo "Waiting for application..."

sleep 10

echo "Checking container..."

docker ps

echo "Checking health..."

docker inspect \
    --format='{{.State.Health.Status}}' \
    kanban-dashboard
