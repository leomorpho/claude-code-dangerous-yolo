#!/bin/bash

# Claude Code Docker Development Environment
# This script sets up and starts a Docker container with Claude Code in unrestricted mode

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Help function
show_help() {
    echo -e "${BLUE}🐳 Claude Code Docker Development Environment${NC}"
    echo "============================================="
    echo ""
    echo "Usage: $0 [OPTIONS] [PROJECT_PATH] [PROJECT_NAME]"
    echo ""
    echo "Options:"
    echo "  -i, --interactive  Start and immediately connect to the container (default)"
    echo "  -d, --detach      Start container in background only"
    echo "  -h, --help        Show this help message"
    echo ""
    echo "Arguments:"
    echo "  PROJECT_PATH  Path to your project directory (default: current directory)"
    echo "  PROJECT_NAME  Name for your project (default: extracted from path)"
    echo ""
    echo "Examples:"
    echo "  $0                                    # Interactive mode, current directory"
    echo "  $0 /path/to/my/project               # Interactive mode, specific project"
    echo "  $0 -d /path/to/my/project           # Background mode, specific project"
    echo "  $0 --interactive ~/code/webapp webapp # Interactive with custom name"
    echo ""
    echo "Environment variables:"
    echo "  PROJECT_PATH  Override project path via environment"
    echo "  PROJECT_NAME  Override project name via environment"
}

# Parse arguments
INTERACTIVE=true
POSITIONAL_ARGS=()

while [[ $# -gt 0 ]]; do
    case $1 in
        -i|--interactive)
            INTERACTIVE=true
            shift
            ;;
        -d|--detach)
            INTERACTIVE=false
            shift
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        -*)
            echo -e "${RED}❌ Unknown option $1${NC}"
            show_help
            exit 1
            ;;
        *)
            POSITIONAL_ARGS+=("$1")
            shift
            ;;
    esac
done

# Restore positional parameters
set -- "${POSITIONAL_ARGS[@]}"

# Set project path and name
PROJECT_PATH="${1:-${PROJECT_PATH:-$(pwd)}}"
PROJECT_NAME="${2:-${PROJECT_NAME:-$(basename "$PROJECT_PATH")}}"

# Convert to absolute path
PROJECT_PATH=$(cd "$PROJECT_PATH" && pwd)

echo -e "${BLUE}🐳 Claude Code Docker Development Environment${NC}"
echo "============================================="
echo -e "${BLUE}Project Path:${NC} $PROJECT_PATH"
echo -e "${BLUE}Project Name:${NC} $PROJECT_NAME"
echo ""

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo -e "${RED}❌ Docker is not running. Please start Docker and try again.${NC}"
    exit 1
fi

# Verify project path exists
if [[ ! -d "$PROJECT_PATH" ]]; then
    echo -e "${RED}❌ Project path does not exist: $PROJECT_PATH${NC}"
    echo -e "${YELLOW}💡 Create the directory first or specify a different path.${NC}"
    exit 1
fi

# Export environment variables for docker-compose
export PROJECT_PATH
export PROJECT_NAME

# Use project-specific docker-compose project name to allow multiple instances
COMPOSE_PROJECT_NAME="claude-dev-${PROJECT_NAME}"
export COMPOSE_PROJECT_NAME

# Check if container is already running
CONTAINER_NAME="claude-dev-${PROJECT_NAME}"
if [[ "$(docker ps -q -f name=${CONTAINER_NAME})" ]]; then
    echo -e "${GREEN}✅ Container already running, reusing existing container!${NC}"
else
    # Build the container if it doesn't exist or if Dockerfile changed
    if [[ ! "$(docker images -q claude-dev 2> /dev/null)" ]] || [[ Dockerfile -nt "$(docker inspect -f '{{.Created}}' claude-dev 2>/dev/null || echo '1970-01-01')" ]]; then
        echo -e "${BLUE}🔨 Building Claude Code container...${NC}"
        docker-compose -p "$COMPOSE_PROJECT_NAME" build
    fi

    # Start the container
    echo -e "${BLUE}🚀 Starting Claude Code container...${NC}"
    docker-compose -p "$COMPOSE_PROJECT_NAME" up -d

    # Wait a moment for the container to be ready
    sleep 2

    echo -e "${GREEN}✅ Container started successfully!${NC}"
fi
echo ""
echo "Your project is mounted at:"
echo -e "${GREEN}  $PROJECT_PATH → /workspace/project${NC}"
echo ""

if [[ "$INTERACTIVE" == true ]]; then
    echo -e "${BLUE}🔗 Connecting to Claude Code environment...${NC}"
    echo -e "${BLUE}Starting Claude in dangerous mode...${NC}"
    echo ""

    # Connect to the container and start Claude automatically
    docker-compose -p "$COMPOSE_PROJECT_NAME" exec claude-dev claude --dangerously-skip-permissions
else
    echo "Container running in background."
    echo ""
    echo "To connect to the Claude Code environment, run:"
    echo -e "${GREEN}./connect.sh $PROJECT_NAME${NC}"
    echo ""
    echo "Or manually:"
    echo -e "${GREEN}docker exec -it claude-dev-${PROJECT_NAME} bash${NC}"
    echo ""
    echo -e "${BLUE}Happy coding with Claude! 🤖${NC}"
fi