#!/bin/bash
# Example development workflow

echo "🚀 Development Workflow Examples"

echo ""
echo "1. Interactive Mode (Default) - Immediately hop into the container:"
echo "   ./start-claude.sh ~/workspace/my-awesome-app"
echo ""

echo "2. Background Mode - Start container and connect later:"
echo "   ./start-claude.sh -d ~/workspace/my-awesome-app"
echo "   ./connect.sh  # Connect when ready"
echo ""

echo "3. Inside the container, you can:"
echo "   - claude chat           # Interactive chat with Claude"
echo "   - claude code          # Code with Claude"
echo "   - npm install          # Install dependencies"
echo "   - python main.py       # Run your code"
echo "   - git status           # Git operations"
echo ""

echo "4. When done, stop the container:"
echo "   docker-compose down"