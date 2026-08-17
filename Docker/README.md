# Debian container setup

This project creates a lightweight Debian-based Linux container with a static IP address, network access, and a sudo-enabled user named `xerxes`.

## Files

- `Dockerfile` — installs Debian packages and creates the user
- `docker-compose.yml` — defines the container, custom network, and static IP
- `connect-debian.ps1` — PowerShell helper to start the container and open a Bash shell

> Debian package names were adjusted to valid packages in the current bookworm repositories. The default Debian repos do not provide packaged `rar`/`unrar`, so `p7zip-full` is used as the supported archive tool equivalent.

## Build and start

From the project root:

```powershell
docker compose -f Docker/docker-compose.yml up -d --build
```

## Access from PowerShell

### Option 1: open a shell in the running container

```powershell
docker exec -it debian-xerxes /bin/bash
```

### Option 2: log in as the non-root user

```powershell
docker exec -it --user xerxes debian-xerxes /bin/bash
```

### Option 3: use the helper script

```powershelln
.\Docker\connect-debian.ps1
```

The script will:

1. Check if Docker is installed
2. Build/start the container if it does not exist
3. Start it if it is stopped
4. Open `/bin/bash` inside the container

## Container details

- Container name: `debian-xerxes`
- Static IP: `172.20.0.10`
- Default shell: `/bin/bash`
- User: `xerxes`
- Password: `P@ssw0rd`
- Sudo access: enabled for `xerxes`

## Example sudo access

```bash
sudo whoami
```

## Internet access inside the container

The custom Docker network uses a bridge and includes DNS entries for:

- `1.1.1.1`
- `8.8.8.8`

This allows the container to reach the internet for package installation and normal networking.

## Package installation inside the container

The image installs these packages:

```bash
tmux nload iftop htop slurm-client zip unzip p7zip-full axel wget curl git net-tools nmap python3 python3-pip python-is-python3 vim nano
```

You can verify versions with:

```bash
python3 --version
pip3 --version
sudo -l
```

## Update and upgrade

The Dockerfile already runs during build:

```bash
apt-get update
apt-get upgrade -y
```

## Helpful commands

```bash
cat /etc/os-release
ip addr show
sudo apt update
sudo apt upgrade -y
```

## Stop the container

```powershell
docker stop debian-xerxes
```

## Remove the container

```powershell
docker rm -f debian-xerxes
```
