#!/bin/bash

# Configuration
GIT_REPO_URL="https://github.com/ManoharGolleru/OS-DPI.git"
PROJECT_DIR="$HOME/OS-DPI"  # Changed to home directory for permission issues
BRANCH="main"

# Ensure the script is stopped on any errors
set -e

# Check if the project directory exists
if [ ! -d "$PROJECT_DIR" ]; then
    # Clone the repo if it does not exist
    echo "Cloning the repository"
    git clone -b $BRANCH $GIT_REPO_URL "$PROJECT_DIR"
else
    # Pull the latest changes if the project already exists
    echo "Pulling latest changes from the repository"
    cd "$PROJECT_DIR"
    git checkout $BRANCH
    git pull origin $BRANCH
fi

# Navigate to the project directory
cd "$PROJECT_DIR" || exit 1

# Install dependencies
echo "Installing dependencies"
npm install
npm install microsoft-cognitiveservices-speech-sdk

# Build the project
echo "Building the project"
npm run build

# Restart the application using PM2
echo "Restarting the application using PM2"
pm2 restart all --update-env || pm2 start npm --name "OS-DPI" -- start

# Inform user of successful deployment
echo "Deployment completed successfully."
