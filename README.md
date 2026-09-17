# Minecraft Server
This repository contains everything required to set up, run, test, and maintain a Minecraft Java Edition server using Docker and Docker Compose.

The project includes:

* Docker configuration for the Minecraft server
* Environment configuration
* Minecraft server configuration
* Persistent world storage
* Server startup and shutdown procedures
* Server status and log management
* Automated restart configuration
* Python-based server connectivity testing with mcstatus
* Persistence testing

The README provides a practical reference for setting up and managing the server locally or on a remote Linux server.
## Table of contents
- [Prerequisites](#prerequisites)
- [Quickstart](#quickstart)
- [Usage](#usage)
- [Testing](#testing)
- [Persistence Test](#Persitence-Test)
- [Useful Docker Commands](#useful-Docker-Commands)

## Prerequisites
Before working with this project, you should have basic knowledge of:

* Terminal / shell commands
* Git
* Docker
* Docker Compose
* Python virtual environments
### Git
Git must be intalled. Check the installed versiion with:
```bash
git --version
```
### Docker
Docker engine must be installed and running correctly.
Check the installed versiion with:
```bash
docker --version
```
`Dockerfile:Describes how the Docker image for the Minecraft server is built.`

Check the docker compose versiion with:
```bash
docker compose --version
```
`Docker-compose.yaml: Describes how the Minecraft container is started and configured, for example ports, volumes, and restart behavior.`

### Python virtual environment
A Python virtual environment is required for the Python-based testing tools.
On Ubuntu, install the required package with:

```bash
sudo apt update
sudo apt install python3-venv -y
```
Create a virtual environment:

```bash
python3 -m venv .venv
```
Activate it:

```bash
source .venv/bin/activate
```
On the windowns Powershell, activate the environment with:
```bash
.\.venv\Scripts\Activate.ps1
```

## Quickstart
### Clone the repository

* Navigate to the directory where you want to store the project.

```bash
cd /path/to/your/projects
```

* Clone the repository from Github.

```bash
git clone git@github.com:Erikogeek/Minecraft-Server.git
```
* Enter the cloned project directory.

```bash
cd minecraft-server
```
### configure the Environment

* Copy the example environment file to the directory.

```bash
cp example.env .env
```
The `.env`file contains environment-specific configuration such as the Minecraft server port.

`MINECRAFT_PORT=8888`.

On Windows PowerShell, the equivalent command is:
```bash
Copy-Item .env.example .env
```
### Start the Minecraft server
Build the Docker image and start the container in detached mode:
```bash
docker compose up -d
```
Explanation:
* docker compose uses the docker-compose.yaml configuration.
* `up` creates and starts the defined services.
* `-d` runs the container in the background.
* `--build` rebuilds the Docker image before starting the container.
Check the container status:
```bash
docker compose ps
```
The expected port mapping is:
`8888->25565/tcp`.  This means:`Host port 8888 → Container port 25565`

## Usage
The project uses a Minecraft Java Edition server running inside a Docker container.

The Minecraft server listens on `port 25565` inside the container.

The host port is configured through the `.env file`:

`MINECRAFT_PORT=8888`

Therefore, the default connection is: `Server-IP:8888`
### Check the server status
```bash
docker compose ps
```
### View the server logs
```bash
docker compose logs
```
To continuously follow the logs:
```bash
docker compose logs -f
```
Press `Ctrl+C` to stop following the logs.
### Stop the server
```bash
docker compose down
```
This stops and removes the Docker container and its Compose network.

The Minecraft world remains stored in the local world/ directory because it is mounted as a Docker volume.
### Start the existing container again
```bash
docker compose up -d
```
### Restart the container
```bash
docker compose restart
```
### Automatic restart
The Docker Compose configuration contains:
`restart: unless-stopped`
This means Docker automatically restarts the Minecraft container after a Docker/server restart, unless the container was explicitly stopped.

## Testing
This project uses the Python package `mcstatus` to test whether the Minecraft server is reachable.
### Install `mcstatus`
Activate the Python virtual environment first. Then install `mcstatus`:

```bash
python3 -m pip install mcstatus
```
Check the installation with:
```bash
python3 -m pip show mcstatus
```
For more about 'mcstatus' check it: `https://github.com/py-mine/mcstatus`
### Create the test script

Create a file called: `test1_minecraft.py`
Example:

```bash
from mcstatus import JavaServer

server = JavaServer.lookup("SERVER_IP:8888")
status = server.status()

print(f"The server is online and reachable!")

print(f"The server nun has: {status.players.online} player(s) online")
print(f"The maximal number of players is: {status.players.max}")
print(f"The actual version of Minecraft is: {status.version.name}")

latency=server.ping()
print(f"The Server replied in {latency} ms")
```
Replace ``SERVER_IP`` with the IP address or hostname of your Minecraft server.
For example:
`server = JavaServer.lookup("2.28.55.49:8888")`
### Execute the test
Run:
```bash
python test1_minecraft.py
```
A successful test should produce output similar to:

`The server is online and reachable!`
`The server nun has: 0 player(s) online`
`The maximal number of players is: 20`
`The actual version of Minecraft is: 26.2`
`The Server replied in 101.64409998105839 ms`
The exact values can differ depending on the server state and network conditions.
### Local testing
If the Minecraft server is running directly on your local machine with the default Minecraft port, the test can use:
`server = JavaServer.lookup("localhost:25565")`

## Persistence Test
The `Minecraft world` must remain available even when the Docker container is removed.
The project therefore mounts the `world/` directory into the container.
### Start the server
```bash
docker compose up -d
```
Check the container:
```bash
docker compose ps
```
The container should show a port mapping similar to:
`8888->25565/tcp`
### Check the Minecraft world
Minecraft automatically creates files inside the `world/` directory.
One important file is:
```bash
ls -lh world/level.dat
```
`level.dat` contains important Minecraft world information.
### Stop and remove Minecraft world information
```bash
docker compose down
```
The Docker container and Compose network are removed.
The `world/` directory is not removed because it is stored on the host.
Check the file again:

```bash
ls -lh world/level.dat
```
The file should still exist.
This demonstrates that the Minecraft world data persists independently of the Docker container.
### Start the server again
```bash
docker compose up -d
```
Check the status:
```bash
docker compose ps
```
Check the logs
```bash
docker compose logs
```
The Minecraft server should load the existing `world/` directory.

## Useful Docker Commands
* Build the Docker image:
```bash
docker compose build
```
Builds the Docker image defined by the project.
* Build and start the server
```bash
docker compose up -d --build
```
Rebuilds the image and starts the server in the background.
* Check this project´s containers
```bash
docker compose ps
```
Shows the containers managed by this Compose project.
* View logs
```bash
docker compose logs
```
* Follow logs continuously
```bash
docker compose logs -f
```
* Stop and remove the Compose container
```bash
docker compose down
```
* Start the project again

```bash
docker compose up -d
```
