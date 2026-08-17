#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Comprehensive Docker management script for ELK Stack + Debian container
    Handles: startup, shutdown, restart, delete, and health checks
.DESCRIPTION
    This script provides complete Docker container lifecycle management
    Operations: containers control, status checks, health monitoring
.EXAMPLE
    .\manage-docker.ps1 -Operation "start-elk"
    .\manage-docker.ps1 -Operation "shutdown-all"
    .\manage-docker.ps1 -Operation "menu"  # Interactive menu (default)
#>

param(
    [Parameter(Mandatory=$false)]
    [ValidateSet("menu","start-elk","start-debian","start-all","stop-elk","stop-debian","shutdown-all","restart-elk","delete-debian","health-check","help")]
    [string]$Operation = "menu"
)

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$composeFile = Join-Path $scriptDir "docker-elk.yml"
$dockerDir = $scriptDir

# Colors for terminal output
$Colors = @{
    Success = 'Green'
    Error = 'Red'
    Warning = 'Yellow'
    Info = 'Cyan'
    Header = 'Magenta'
}

function Write-ColorOutput {
    param([string]$Message, [string]$Color = 'White')
    Write-Host $Message -ForegroundColor $Color
}

function Show-Header {
    param([string]$Title)
    Write-Host "`n" -NoNewline
    Write-ColorOutput "==========================================================" $Colors.Header
    Write-ColorOutput "  $Title" $Colors.Header
    Write-ColorOutput "==========================================================" $Colors.Header
    Write-Host ""
}

function Show-Menu {
    Show-Header "Docker Container Management Menu"
    Write-Host "
  1) Start Elasticsearch + Kibana (ELK)
  2) Start Debian Container
  3) Start All (ELK + Debian)
  4) Stop Elasticsearch + Kibana
  5) Stop Debian Container
  6) Shutdown All Containers
  7) Restart Elasticsearch + Kibana
  8) Delete & Purge Debian Container
  9) Health Check (Curl 5601 + 9200)
  0) Exit

" -ForegroundColor Cyan
    $choice = Read-Host "Select an option (0-9)"
    return $choice
}

function Start-ELKStack {
    Show-Header "Starting Elasticsearch + Kibana"
    try {
        Set-Location $dockerDir
        Write-ColorOutput ">> Starting Elasticsearch & Kibana from docker-elk.yml..." $Colors.Info
        docker-compose -f $composeFile up -d
        Start-Sleep -Seconds 3
        Write-ColorOutput "[OK] ELK Stack started successfully" $Colors.Success
        Get-ContainerStatus
    }
    catch {
        Write-ColorOutput "[ERROR] Error starting ELK Stack: $_" $Colors.Error
    }
}

function Start-DebianContainer {
    Show-Header "Starting Debian Container"
    try {
        $debianComposeFile = Join-Path $dockerDir "docker-compose.yml"
        Write-ColorOutput ">> Starting Debian container from docker-compose.yml..." $Colors.Info
        docker-compose -f $debianComposeFile up -d
        Start-Sleep -Seconds 2
        Write-ColorOutput "[OK] Debian container started successfully" $Colors.Success
        Get-ContainerStatus
    }
    catch {
        Write-ColorOutput "[ERROR] Error starting Debian container: $_" $Colors.Error
    }
}

function Start-AllContainers {
    Show-Header "Starting All Containers"
    Start-ELKStack
    Start-DebianContainer
}

function Stop-ELKStack {
    Show-Header "Stopping Elasticsearch + Kibana"
    try {
        Set-Location $dockerDir
        Write-ColorOutput ">> Stopping Elasticsearch container..." $Colors.Info
        docker stop elasticsearch -t 10
        Write-ColorOutput ">> Stopping Kibana container..." $Colors.Info
        docker stop kibana -t 10
        Start-Sleep -Seconds 2
        Write-ColorOutput "[OK] ELK Stack stopped successfully" $Colors.Success
        Get-ContainerStatus
    }
    catch {
        Write-ColorOutput "[ERROR] Error stopping ELK Stack: $_" $Colors.Error
    }
}

function Stop-DebianContainer {
    Show-Header "Stopping Debian Container"
    try {
        Write-ColorOutput ">> Stopping Debian container..." $Colors.Info
        docker stop debian -t 10
        Start-Sleep -Seconds 1
        Write-ColorOutput "[OK] Debian container stopped successfully" $Colors.Success
        Get-ContainerStatus
    }
    catch {
        Write-ColorOutput "[ERROR] Error stopping Debian container: $_" $Colors.Error
    }
}

function Shutdown-AllContainers {
    Show-Header "Shutting Down All Containers"
    try {
        Write-ColorOutput ">> Stopping all running containers..." $Colors.Warning
        $runningContainers = docker ps -q
        if ($runningContainers) {
            docker stop $runningContainers -t 10
            Start-Sleep -Seconds 2
        }
        Write-ColorOutput "[OK] All containers stopped successfully" $Colors.Success
        Get-ContainerStatus
    }
    catch {
        Write-ColorOutput "[ERROR] Error shutting down containers: $_" $Colors.Error
    }
}

function Restart-ELKStack {
    Show-Header "Restarting Elasticsearch + Kibana"
    try {
        Set-Location $dockerDir
        Write-ColorOutput ">> Stopping ELK containers..." $Colors.Info
        docker stop elasticsearch kibana -t 10
        Start-Sleep -Seconds 2
        Write-ColorOutput ">> Starting ELK containers..." $Colors.Info
        docker start elasticsearch kibana
        Start-Sleep -Seconds 5
        Write-ColorOutput "[OK] ELK Stack restarted successfully" $Colors.Success
        Get-ContainerStatus
    }
    catch {
        Write-ColorOutput "[ERROR] Error restarting ELK Stack: $_" $Colors.Error
    }
}

function Delete-PurgeDebianContainer {
    Show-Header "Delete & Purge Debian Container"
    Write-ColorOutput "[WARNING] This will completely remove the Debian container and its data" $Colors.Warning
    $confirm = Read-Host "Are you sure? Type 'YES' to confirm"
    
    if ($confirm -eq "YES") {
        try {
            Set-Location $dockerDir
            Write-ColorOutput ">> Stopping Debian container..." $Colors.Info
            docker stop debian -t 10 -ErrorAction SilentlyContinue
            Start-Sleep -Seconds 1
            
            Write-ColorOutput ">> Removing Debian container..." $Colors.Info
            docker rm debian -f
            
            Write-ColorOutput ">> Removing associated volumes..." $Colors.Info
            docker volume prune -f
            
            Write-ColorOutput "[OK] Debian container and volumes deleted successfully" $Colors.Success
            Get-ContainerStatus
        }
        catch {
            Write-ColorOutput "[ERROR] Error deleting Debian container: $_" $Colors.Error
        }
    }
    else {
        Write-ColorOutput "[CANCELLED] Operation cancelled" $Colors.Warning
    }
}

function Get-HealthCheck {
    Show-Header "Health Check - Connectivity Test"
    
    $elasticUrl = "http://localhost:9200"
    $kibanaUrl = "http://localhost:5601"
    $credentials = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes("elastic:ChangeMe123!"))
    $headers = @{ Authorization = "Basic $credentials"; "Content-Type" = "application/json" }
    
    # Test Elasticsearch
    Write-ColorOutput "Testing Elasticsearch (Port 9200)..." $Colors.Info
    Write-ColorOutput "-----------------------------------" $Colors.Header
    try {
        $esResponse = Invoke-RestMethod -Uri $elasticUrl -Headers $headers -TimeoutSec 10
        Write-ColorOutput "[OK] Elasticsearch: RUNNING" $Colors.Success
        Write-Host "  Cluster: $($esResponse.cluster_name)"
        Write-Host "  Node: $($esResponse.name)"
        Write-Host "  Version: $($esResponse.version.number)"
        Write-Host "  Status: $($esResponse.status)"
    }
    catch {
        Write-ColorOutput "[FAIL] Elasticsearch: NOT RESPONDING" $Colors.Error
        Write-Host "  URL: $elasticUrl"
        Write-Host "  Error: $($_.Exception.Message)" -ForegroundColor Yellow
    }
    
    # Test Kibana
    Write-Host ""
    Write-ColorOutput "Testing Kibana (Port 5601)..." $Colors.Info
    Write-ColorOutput "-----------------------------------" $Colors.Header
    try {
        $kibanaResponse = Invoke-WebRequest -Uri "$kibanaUrl/api/status" -TimeoutSec 10
        if ($kibanaResponse.StatusCode -eq 200) {
            Write-ColorOutput "[OK] Kibana: RUNNING" $Colors.Success
            Write-Host "  Status: HTTP 200 OK"
            Write-Host "  Endpoint: $kibanaUrl/app/discover"
        }
    }
    catch {
        Write-ColorOutput "[FAIL] Kibana: NOT RESPONDING" $Colors.Error
        Write-Host "  URL: $kibanaUrl"
        Write-Host "  Error: $($_.Exception.Message)" -ForegroundColor Yellow
    }
    
    # Container Status Summary
    Write-Host ""
    Get-ContainerStatus
}

function Get-ContainerStatus {
    Write-Host ""
    Write-ColorOutput "Active Containers:" $Colors.Header
    Write-ColorOutput "-----------------------------------" $Colors.Header
    docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
}

function Show-Help {
    Show-Header "Help & Usage Information"
    Write-Host "
USAGE:
  .\manage-docker.ps1 [-Operation] <operation>

OPERATIONS:
  menu              - Interactive menu (default)
  start-elk         - Start Elasticsearch & Kibana
  start-debian      - Start Debian container
  start-all         - Start all containers (ELK + Debian)
  stop-elk          - Stop Elasticsearch & Kibana
  stop-debian       - Stop Debian container
  shutdown-all      - Shutdown all running containers
  restart-elk       - Restart Elasticsearch & Kibana
  delete-debian     - Delete and purge Debian container
  health-check      - Test connectivity to ES and Kibana
  help              - Show this help message

EXAMPLES:
  .\manage-docker.ps1                    # Opens interactive menu
  .\manage-docker.ps1 -Operation start-elk
  .\manage-docker.ps1 -Operation health-check
  .\manage-docker.ps1 -Operation shutdown-all

REQUIREMENTS:
  - Docker Desktop installed and running
  - PowerShell 5.0+
  - docker-compose command available

NOTES:
  - All timestamps use UTC+0
  - Containers: elasticsearch, kibana, debian
  - Volumes: esdata
  - Network: elastic (bridge)
" -ForegroundColor Cyan
}

# Main execution
function Invoke-Operation {
    param([string]$Op)
    
    switch ($Op) {
        "1" { Start-ELKStack }
        "2" { Start-DebianContainer }
        "3" { Start-AllContainers }
        "4" { Stop-ELKStack }
        "5" { Stop-DebianContainer }
        "6" { Shutdown-AllContainers }
        "7" { Restart-ELKStack }
        "8" { Delete-PurgeDebianContainer }
        "9" { Get-HealthCheck }
        "0" { 
            Write-ColorOutput "`n[OK] Goodbye!" $Colors.Success
            exit 0 
        }
        "start-elk" { Start-ELKStack }
        "start-debian" { Start-DebianContainer }
        "start-all" { Start-AllContainers }
        "stop-elk" { Stop-ELKStack }
        "stop-debian" { Stop-DebianContainer }
        "shutdown-all" { Shutdown-AllContainers }
        "restart-elk" { Restart-ELKStack }
        "delete-debian" { Delete-PurgeDebianContainer }
        "health-check" { Get-HealthCheck }
        "help" { Show-Help }
        "menu" {
            do {
                $choice = Show-Menu
                if ($choice -ne "0") {
                    Invoke-Operation $choice
                    Write-Host ""
                    Read-Host "Press Enter to continue"
                }
            } while ($choice -ne "0")
        }
        default {
            Write-ColorOutput "[ERROR] Invalid operation: $Op" $Colors.Error
            Show-Help
            exit 1
        }
    }
}

# Start
Set-Location $dockerDir
Invoke-Operation $Operation
