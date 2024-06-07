#!/bin/bash

# Stop and remove the existing container
docker stop nodejs-app || true
docker rm nodejs-app || true

# Run the new container
docker run -d --name nodejs-app -p 4444:4444 vasesdas/nodejs-app:${GITHUB_SHA}

