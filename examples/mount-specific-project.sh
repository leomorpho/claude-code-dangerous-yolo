#!/bin/bash
# Example: Mount a specific project directory

# Mount your React app
./start-claude.sh ~/Documents/my-react-app react-app

# Mount your Python project
./start-claude.sh /path/to/python/project data-pipeline

# Mount with environment variables
PROJECT_PATH="/home/user/workspace/api" PROJECT_NAME="my-api" ./start-claude.sh