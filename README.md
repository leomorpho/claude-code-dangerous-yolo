# Claude Code Docker Development Environment

A reusable Docker container setup for running Claude Code in unrestricted mode with any project directory mounted and synced.

## Quick Start

1. **Copy this directory anywhere on your system**
2. **Mount any project:**
   ```bash
   ./start-claude.sh /path/to/your/project
   ```
3. **Connect to Claude Code:**
   ```bash
   ./connect.sh
   ```

## What's Included

- **Ubuntu 22.04** base image
- **Claude Code CLI** installed and configured in unrestricted mode
- **Development tools:** Python3, Node.js, npm, Git, Docker CLI, build tools
- **Volume mounts** for seamless file sync between host and container
- **Persistent home directory** to save Claude Code settings

## Directory Structure

```
docker-claude-dev/
├── Dockerfile              # Container definition
├── docker-compose.yml      # Container orchestration
├── start-claude.sh         # Setup and start script
├── connect.sh             # Quick connect script
└── examples/              # Usage examples
    ├── mount-current-dir.sh
    ├── mount-specific-project.sh
    └── development-workflow.sh
```

## Usage

### Interactive Mode (Default)
Automatically connects you to the container after starting:
```bash
./start-claude.sh                           # Current directory
./start-claude.sh /path/to/your/project    # Specific project
./start-claude.sh -i ~/code/webapp         # Explicit interactive flag
```

### Background Mode
Starts container in background only:
```bash
./start-claude.sh -d /path/to/your/project  # Background mode
./start-claude.sh --detach ~/code/webapp   # Background mode
```

### Using Environment Variables
```bash
PROJECT_PATH="/home/user/code/webapp" ./start-claude.sh
```

### Help
```bash
./start-claude.sh --help
```

This will:
- Verify the project path exists
- Build the Docker container (if needed)
- Mount your specified directory to `/workspace/project`
- Start the container in the background
- Show connection instructions

### Connecting to Claude Code
```bash
./connect.sh
```
Or manually:
```bash
docker-compose exec claude-dev bash
```

### Stopping the Environment
```bash
docker-compose down
```

### Rebuilding the Container
```bash
docker-compose build --no-cache
```

## Configuration

### Environment Variables
- `CLAUDE_UNRESTRICTED=true` - Enables unrestricted mode
- Add more in `docker-compose.yml` under `environment:`

### Volume Mounts
The container automatically mounts your specified project directory to `/workspace/project`. You can also override this using environment variables:

```bash
PROJECT_PATH="/custom/path" ./start-claude.sh
```

### Ports
Uncomment and modify the ports section in `docker-compose.yml`:
```yaml
ports:
  - "3000:3000"  # host:container
```

## File Sync

Your entire project directory is mounted and automatically synced between your local machine and the container at `/workspace/project`. Changes made in either location are immediately reflected in the other.

## Usage Examples

### Work on a React App
```bash
./start-claude.sh ~/Documents/my-react-app
./connect.sh
# Inside container: npm install && npm start
```

### Work on a Python Project
```bash
./start-claude.sh /path/to/python/project data-science
./connect.sh  
# Inside container: pip install -r requirements.txt && python main.py
```

### Portable Setup
Copy the `docker-claude-dev/` directory to any location and use it to work on any project:
```bash
cp -r docker-claude-dev ~/tools/
~/tools/docker-claude-dev/start-claude.sh ~/workspace/any-project
```

## Troubleshooting

### Docker not running
Make sure Docker Desktop is started before running the scripts.

### Permission issues
If you encounter permission issues, make sure the scripts are executable:
```bash
chmod +x start-claude.sh connect.sh
```

### Container won't start
Check the logs:
```bash
docker-compose logs claude-dev
```

### Rebuilding after changes
If you modify the Dockerfile:
```bash
docker-compose build --no-cache
./start-claude.sh
```

## Advanced Usage

### Running Claude Code commands
Once connected to the container, first set up the PATH:
```bash
export PATH="/home/developer/.local/bin:$PATH"
claude --version  # Verify installation
claude --help     # Get help
claude chat       # Interactive chat
claude code       # Code with Claude
```

Or use the alias (if available):
```bash
claude  # Should work with --dangerously-skip-permissions
```

### Accessing Docker from within container
The Docker CLI is available inside the container and can communicate with your host Docker daemon (docker-in-docker is enabled).

### Customizing the environment
Edit the Dockerfile to add more tools or change the base configuration to suit your needs.