# Docker Quick Reference Card

## START-UP SEQUENCES

### Quick Start Everything
```powershell
.\manage-docker.ps1 -Operation "start-all"
```

### Start Only ELK Stack
```powershell
.\manage-docker.ps1 -Operation "start-elk"
```

### Start Only Debian
```powershell
.\manage-docker.ps1 -Operation "start-debian"
```

---

## SHUTDOWN & STOP

### Stop ELK Stack
```powershell
.\manage-docker.ps1 -Operation "stop-elk"
```

### Stop Debian
```powershell
.\manage-docker.ps1 -Operation "stop-debian"
```

### Stop Everything
```powershell
.\manage-docker.ps1 -Operation "shutdown-all"
```

---

## MAINTENANCE

### Restart ELK Stack
```powershell
.\manage-docker.ps1 -Operation "restart-elk"
```

### Delete Debian (with confirmation)
```powershell
.\manage-docker.ps1 -Operation "delete-debian"
```

### Check Health (Ports 9200 & 5601)
```powershell
.\manage-docker.ps1 -Operation "health-check"
```

---

## INTERACTIVE MODE

### Open Menu
```powershell
.\manage-docker.ps1
# or
.\manage-docker.ps1 -Operation "menu"
```

### Show Help
```powershell
.\manage-docker.ps1 -Operation "help"
```

---

## ACCESS POINTS

| Service | URL | Port |
|---------|-----|------|
| Kibana | http://localhost:5601 | 5601 |
| Elasticsearch | http://localhost:9200 | 9200 |
| Discover | http://localhost:5601/app/discover | 5601 |
| Data View | forti-attack-sample-index | - |

---

## CREDENTIALS

```
Elastic User:        elastic
Elastic Password:    ChangeMe123!
Kibana System User:  kibana_system
Kibana System Pass:  rvRefEvAb0I0LQWHFmS3
Debian User:         xerxes
Debian Password:     P@ssw0rd
```

---

## TROUBLESHOOTING SHORTCUTS

```powershell
# Health Check (diagnoses connection issues)
.\manage-docker.ps1 -Operation "health-check"

# Full Restart (fixes most issues)
.\manage-docker.ps1 -Operation "restart-elk"

# View Active Containers
docker ps

# View Container Logs
docker logs elasticsearch
docker logs kibana

# Stop Everything & Start Fresh
.\manage-docker.ps1 -Operation "shutdown-all"
.\manage-docker.ps1 -Operation "start-all"
```

---

## WORKFLOW EXAMPLES

### Daily Morning Start
```powershell
.\manage-docker.ps1 -Operation "start-all"
.\manage-docker.ps1 -Operation "health-check"
# Verify both are running
```

### End of Day Shutdown
```powershell
.\manage-docker.ps1 -Operation "shutdown-all"
```

### Fix Connection Issues
```powershell
.\manage-docker.ps1 -Operation "restart-elk"
Start-Sleep -Seconds 10
.\manage-docker.ps1 -Operation "health-check"
```

### Clean Restart (Preserve Data)
```powershell
.\manage-docker.ps1 -Operation "shutdown-all"
Start-Sleep -Seconds 3
.\manage-docker.ps1 -Operation "start-all"
```

---

## DIRECTORY STRUCTURE

```
Docker/
├── manage-docker.ps1       ← RUN THIS
├── MANAGEMENT_GUIDE.md     ← Read for details
├── docker-elk.yml          ← ELK config
├── docker-compose.yml      ← Debian config
├── Dockerfile              ← Debian build
└── README.md               ← Original docs
```

---

**Location:** D:\Khashayar\Vscode\XXVI\Docker  
**Script:** manage-docker.ps1  
**Mode:** PowerShell 5.0+  
