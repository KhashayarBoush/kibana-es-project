# Docker Management Guide

## Quick Start

### Using the Management Script
Navigate to the Docker directory and run:

```powershell
cd D:\Khashayar\Vscode\XXVI\Docker
.\manage-docker.ps1
```

### Available Operations

#### Interactive Menu (Default)
```powershell
.\manage-docker.ps1 -Operation "menu"
# Opens interactive menu with 10 options
```

#### Direct Operations
```powershell
# Start Operations
.\manage-docker.ps1 -Operation "start-elk"        # Start Elasticsearch + Kibana
.\manage-docker.ps1 -Operation "start-debian"     # Start Debian container
.\manage-docker.ps1 -Operation "start-all"        # Start everything

# Stop Operations
.\manage-docker.ps1 -Operation "stop-elk"         # Stop ELK stack
.\manage-docker.ps1 -Operation "stop-debian"      # Stop Debian
.\manage-docker.ps1 -Operation "shutdown-all"     # Shutdown all containers

# Management Operations
.\manage-docker.ps1 -Operation "restart-elk"      # Restart ELK stack
.\manage-docker.ps1 -Operation "delete-debian"    # Delete & purge Debian

# Monitoring
.\manage-docker.ps1 -Operation "health-check"     # Test connectivity (ports 9200 & 5601)
.\manage-docker.ps1 -Operation "help"             # Show help
```

## Directory Structure

```
Docker/
├── manage-docker.ps1       ← Main management script (ALL-IN-ONE)
├── docker-elk.yml          ← ELK Stack (Elasticsearch + Kibana)
├── docker-compose.yml      ← Debian container
├── Dockerfile              ← Debian build configuration
├── README.md               ← Documentation
```

## Containers & Ports

| Service | Container | Port | Status |
|---------|-----------|------|--------|
| Elasticsearch | elasticsearch | 9200 | Running |
| Kibana | kibana | 5601 | Running |
| Debian | debian-xerxes | SSH/Bash | On Demand |

## Access Points

- **Kibana Web UI**: http://localhost:5601
- **Elasticsearch API**: http://localhost:9200
- **Kibana Discover**: http://localhost:5601/app/discover
- **Debian Shell**: Via `manage-docker.ps1` (start debian, then exec bash)

## Credentials

```
Elasticsearch User: elastic
Elasticsearch Password: ChangeMe123!
Kibana System User: kibana_system
Kibana System Password: rvRefEvAb0I0LQWHFmS3
Debian User: xerxes
Debian Password: P@ssw0rd
```

## Key Features of manage-docker.ps1

✓ Color-coded output (Success, Error, Warning, Info)  
✓ Status monitoring (view active containers)  
✓ Health checks (connectivity to ES & Kibana)  
✓ Container lifecycle management  
✓ Data volume management  
✓ Safe deletion with confirmation  
✓ Timeout handling (10s graceful stop, then force)  
✓ Menu-driven or command-line operations  

## Example Workflows

### Complete System Startup
```powershell
.\manage-docker.ps1 -Operation "start-all"
```

### Daily Restart (Fix Connection Issues)
```powershell
.\manage-docker.ps1 -Operation "restart-elk"
```

### System Shutdown
```powershell
.\manage-docker.ps1 -Operation "shutdown-all"
```

### Health Verification
```powershell
.\manage-docker.ps1 -Operation "health-check"
```

## Troubleshooting

### Elasticsearch not responding
1. Check status: `docker ps`
2. View logs: `docker logs elasticsearch`
3. Restart: `.\manage-docker.ps1 -Operation "restart-elk"`

### Kibana shows "Server not ready"
1. Ensure Elasticsearch is running
2. Wait 10-15 seconds after starting ES
3. Restart Kibana: `.\manage-docker.ps1 -Operation "restart-elk"`

### Port already in use
1. Find process: `netstat -ano | findstr :9200` or `:5601`
2. Stop container: `docker stop <container_id>`
3. Retry: `.\manage-docker.ps1 -Operation "start-elk"`

## Notes

- All containers use a bridge network (`elastic` network)
- Elasticsearch data persists in `esdata` volume
- Debian container rebuilds from `Dockerfile` on first start
- All operations include graceful shutdown with timeout
- Security is enabled on Elasticsearch (xpack.security.enabled=true)
