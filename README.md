# Claude Code Docker Development Environment

A reusable Docker container setup for running Claude Code in unrestricted mode with any project directory mounted and synced.

## Why Run Claude in a Docker Sandbox? 🔒

Running Claude with `--dangerously-skip-permissions` is like giving a hyperintelligent AI the keys to your entire machine. Sure, it's *probably* fine, but do you really want to find out what "probably" means when Claude decides your `/etc` directory needs "refactoring"?

**This Docker setup lets you:**
- Give Claude full unrestricted access... to a sandbox 🏖️
- Watch it `rm -rf` to its heart's content (inside the container)
- Sleep soundly knowing your host system remains untouched
- Easily nuke and rebuild if Claude gets too creative with system files
- Avoid awkward conversations about why your production database is now in `/tmp`

Think of it as a padded room for AI experimentation. Claude gets to feel free and powerful, while your actual machine stays safe from "helpful" system-level optimizations.

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

**Multiple Projects:** You can run multiple containers simultaneously, each working on different projects. Each container is isolated with its own settings and state.

## What's Included

- **Ubuntu 22.04** base image
- **Claude Code CLI** installed and synced with your host configuration
- **Development tools:** Python3, PNPM, Node.js (latest), Go 1.23.5, Git, Docker CLI, uv, build tools
- **Volume mounts** for seamless file sync between host and container
- **Persistent home directory** to save Claude Code settings
- **Shared .claude directory** - your auth and settings sync automatically

## Directory Structure

```
docker-claude-dev/
├── Dockerfile              # Container definition
├── docker-compose.yml      # Container orchestration
├── start-claude.sh         # Setup and start script
├── connect.sh              # Quick connect script
└── entrypoint.sh           # Container entrypoint
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
./connect.sh                  # Connects to container for current directory
./connect.sh project-name     # Connects to specific project container
```
Or manually:
```bash
docker exec -it claude-dev-project-name bash
```

### Starting Claude Code
Once connected to the container, start Claude normally:
```bash
claude                                             # Start Claude
claude --dangerously-skip-permissions              # Start in dangerous mode
claude --resume                                    # Resume previous session
```

**Note:** Your host `.claude` directory is mounted, so auth and settings are shared automatically.

### Stopping the Environment
Stop a specific project:
```bash
docker stop claude-dev-project-name
```
Stop all Claude containers:
```bash
docker stop $(docker ps -q --filter "name=claude-dev-")
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

### Multiple Projects Simultaneously
Run different containers for different projects:
```bash
./start-claude.sh ~/workspace/frontend
./start-claude.sh ~/workspace/backend
./start-claude.sh ~/workspace/mobile-app

# Connect to specific projects
./connect.sh frontend
./connect.sh backend
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
The `claude` command is automatically available in your PATH:
```bash
claude                                             # Start Claude normally
claude --dangerously-skip-permissions              # Start in dangerous mode
claude --resume                                    # Resume previous session
```

**Note:** Your `.claude` directory from the host is mounted into the container, so all your auth and settings are automatically available.

### Accessing Docker from within container
The Docker CLI is available inside the container and can communicate with your host Docker daemon (docker-in-docker is enabled).

### Customizing the environment
Edit the Dockerfile to add more tools or change the base configuration to suit your needs.