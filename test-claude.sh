#!/bin/bash

# Test Claude Code installation in the container

echo "🔍 Testing Claude Code installation..."

# Connect to container and test claude command
docker-compose exec claude-dev bash -c "
    export PATH=\"/home/developer/.local/bin:\$PATH\"
    which claude
    claude --version
"