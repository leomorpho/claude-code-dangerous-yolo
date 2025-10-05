#!/bin/bash

# Quick script to connect to a running Claude Code container
# Usage: ./connect.sh [PROJECT_NAME]

PROJECT_NAME="${1:-$(basename $(pwd))}"

echo "🔗 Connecting to Claude Code container for project: $PROJECT_NAME"

# Try using docker-compose first
COMPOSE_PROJECT_NAME="claude-dev-${PROJECT_NAME}"
if docker-compose -p "$COMPOSE_PROJECT_NAME" ps | grep -q "Up"; then
    docker-compose -p "$COMPOSE_PROJECT_NAME" exec claude-dev claude --dangerously-skip-permissions
else
    # Fallback to direct docker exec
    CONTAINER_NAME="claude-dev-${PROJECT_NAME}"
    if docker ps --filter "name=${CONTAINER_NAME}" --format '{{.Names}}' | grep -q "${CONTAINER_NAME}"; then
        docker exec -it "${CONTAINER_NAME}" claude --dangerously-skip-permissions
    else
        echo "❌ No running container found for project: $PROJECT_NAME"
        echo "Available Claude containers:"
        docker ps --filter "name=claude-dev-" --format "  - {{.Names}}" || echo "  None"
        exit 1
    fi
fi