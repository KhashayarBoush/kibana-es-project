#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Complete GitHub Push Automation Script
    Handles: git initialization, configuration, commit, and push
.DESCRIPTION
    One-command solution to push your project to GitHub
.PARAMETER RepoUrl
    Your GitHub repository HTTPS URL (required)
.PARAMETER ProjectPath
    Path to your project (default: D:\Khashayar\Vscode\XXVI)
.EXAMPLE
    .\github-push-complete.ps1 -RepoUrl "https://github.com/KhashayarBoush/es-kibana-project.git"
#>

param(
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]$RepoUrl,
    
    [Parameter(Mandatory=$false)]
    [string]$ProjectPath = "D:\Khashayar\Vscode\XXVI"
)

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
    Write-ColorOutput "`n════════════════════════════════════════════════════════════" $Colors.Header
    Write-ColorOutput "  $Title" $Colors.Header
    Write-ColorOutput "════════════════════════════════════════════════════════════" $Colors.Header
}

# Main execution
Show-Header "GitHub Push - Complete Automation"

# Step 1: Verify Git is installed
Write-ColorOutput "`n[1/7] Checking Git installation..." $Colors.Info
try {
    $gitVersion = & git --version
    Write-ColorOutput "[OK] Found: $gitVersion" $Colors.Success
} catch {
    Write-ColorOutput "[ERROR] Git is not installed!" $Colors.Error
    Write-Host "Download from: https://git-scm.com/download/win" -ForegroundColor Yellow
    exit 1
}

# Step 2: Verify project path
Write-ColorOutput "`n[2/7] Verifying project path..." $Colors.Info
if (Test-Path $ProjectPath) {
    Write-ColorOutput "[OK] Project found at: $ProjectPath" $Colors.Success
} else {
    Write-ColorOutput "[ERROR] Project path not found: $ProjectPath" $Colors.Error
    exit 1
}

# Step 3: Navigate to project
Write-ColorOutput "`n[3/7] Navigating to project directory..." $Colors.Info
Set-Location $ProjectPath
Write-ColorOutput "[OK] Current directory: $(Get-Location)" $Colors.Success

# Step 4: Initialize Git (if needed)
Write-ColorOutput "`n[4/7] Initializing Git repository..." $Colors.Info
if (Test-Path ".\.git") {
    Write-ColorOutput "[INFO] Git repository already exists" $Colors.Warning
} else {
    git init
    Write-ColorOutput "[OK] Git repository initialized" $Colors.Success
}

# Step 5: Configure Git user
Write-ColorOutput "`n[5/7] Configuring Git user..." $Colors.Info
$userName = git config user.name
$userEmail = git config user.email

if (-not $userName -or -not $userEmail) {
    if (-not $userName) {
        $userName = "Khashayar Boush"
        git config --global user.name $userName
    }
    if (-not $userEmail) {
        Write-Host "Enter your email address: " -ForegroundColor Cyan -NoNewline
        $userEmail = Read-Host
        git config --global user.email $userEmail
    }
}
Write-ColorOutput "[OK] Configured as: $userName <$userEmail>" $Colors.Success

# Step 6: Add files and commit
Write-ColorOutput "`n[6/7] Adding files and creating commit..." $Colors.Info
git add .
$fileCount = & git ls-files | Measure-Object -Line
Write-ColorOutput "[OK] Added $($fileCount.Lines) files" $Colors.Success

$commitMsg = "Initial commit: ELK Stack with Elasticsearch + Kibana Docker setup, FortiGate attack logs, and comprehensive Docker management scripts"
git commit -m $commitMsg
Write-ColorOutput "[OK] Commit created" $Colors.Success

# Step 7: Add remote and push
Write-ColorOutput "`n[7/7] Pushing to GitHub..." $Colors.Info

# Remove existing remote if present
$existingRemote = git remote get-url origin 2>$null
if ($existingRemote) {
    Write-ColorOutput "[INFO] Removing existing remote..." $Colors.Warning
    git remote remove origin
}

# Add new remote
git remote add origin $RepoUrl
Write-ColorOutput "[OK] Remote added" $Colors.Success

# Set branch to main
git branch -M main
Write-ColorOutput "[OK] Branch set to main" $Colors.Success

# Push to GitHub
Write-ColorOutput "[INFO] Pushing to GitHub (you may be prompted to log in)..." $Colors.Warning
git push -u origin main

# Summary
Show-Header "SUCCESS - Project Pushed to GitHub!"

Write-Host "
Repository Details:
  Name: es-kibana-project
  Owner: KhashayarBoush
  URL: $RepoUrl
  Branch: main
  Files: $($fileCount.Lines)

Next Steps:
  1. Visit: $($RepoUrl -replace '.git', '')
  2. Verify all files are there
  3. Share the link with others
  4. Future pushes: git add . && git commit -m 'message' && git push

" -ForegroundColor Cyan

Write-ColorOutput "`nProject is now backed up on GitHub!" $Colors.Success
