FROM ubuntu:22.04

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    python3 \
    python3-pip \
    nodejs \
    npm \
    make \
    gcc \
    g++ \
    build-essential \
    ca-certificates \
    gnupg \
    lsb-release \
    sudo \
    vim \
    && rm -rf /var/lib/apt/lists/*

# Install Docker CLI (for docker-in-docker scenarios)
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && apt-get update && apt-get install -y docker-ce-cli && rm -rf /var/lib/apt/lists/*

# Create a user for development
RUN useradd -m -s /bin/bash developer && \
    echo 'developer ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Set working directory
WORKDIR /workspace

# Switch to developer user
USER developer

# Install Claude Code CLI as the developer user with proper HOME
ENV HOME=/home/developer
RUN curl -fsSL https://claude.ai/install.sh | HOME=/home/developer bash

# Set up Claude Code in unrestricted mode and ensure it's in PATH
RUN echo 'export CLAUDE_UNRESTRICTED=true' >> /home/developer/.bashrc && \
    echo 'export PATH="/home/developer/.local/bin:$PATH"' >> /home/developer/.bashrc && \
    echo 'alias claude="claude --dangerously-skip-permissions"' >> /home/developer/.bashrc

# Create Claude config directory and set up restricted permissions
RUN mkdir -p /home/developer/.claude && \
    echo '{"permissions": {"allow": ["*"], "deny": [], "ask": []}, "additionalDirectories": ["/workspace/project"]}' > /home/developer/.claude/config.json

# Ensure the PATH is set for interactive shells
RUN echo 'if [ -f ~/.bashrc ]; then source ~/.bashrc; fi' >> /home/developer/.bash_profile

# Ensure Claude CLI is in PATH for this build
ENV PATH="/home/developer/.local/bin:$PATH"

# Keep container running
CMD ["bash", "-c", "while true; do sleep 30; done"]