# GitHub Push Guide - Complete Step-by-Step

## Overview
This guide walks you through:
1. Creating a GitHub repository
2. Installing Git (if needed)
3. Pushing your es-kibana-project to GitHub

---

## STEP 1: Create GitHub Repository (Manual)

**Why Manual?** GitHub's form uses React validation that requires manual interaction.

### Instructions:

1. **Go to GitHub New Repository Page**
   - URL: https://github.com/new
   - Or click the "+" icon in top-right of GitHub → "New repository"

2. **Fill in Repository Details**

   | Field | Value |
   |-------|-------|
   | Repository name | `es-kibana-project` |
   | Description | `Elasticsearch + Kibana Docker Stack with ELK Setup, FortiGate attack logs, and comprehensive Docker management scripts` |
   | Visibility | Public (or Private, your choice) |
   | Add README | ❌ NO (uncheck) |
   | Add .gitignore | ❌ NO (uncheck) |
   | Add license | ❌ NO (uncheck) |

3. **Click "Create repository"**
   - Wait for the page to load
   - You should see your empty repository page

4. **Copy Your Repository URL**
   - Click the green "Code" button
   - Copy the HTTPS URL
   - Example: `https://github.com/KhashayarBoush/es-kibana-project.git`

---

## STEP 2: Install Git (if you haven't already)

### Check if Git is installed:
```powershell
git --version
```

### If not installed:
1. Download: https://git-scm.com/download/win
2. Run the installer
3. Accept all default options
4. Restart PowerShell

---

## STEP 3: Configure Git (First Time Only)

Run these commands in PowerShell:

```powershell
git config --global user.name "Khashayar Boush"
git config --global user.email "your.email@example.com"
```

---

## STEP 4: Initialize Repository & Push

Navigate to your project and run these commands:

```powershell
# Navigate to your project
cd "D:\Khashayar\Vscode\XXVI"

# Initialize git
git init

# Add all files
git add .

# Create commit
git commit -m "Initial commit: ELK Stack with Elasticsearch + Kibana Docker setup, FortiGate attack logs, and Docker management scripts"

# Add remote (replace with YOUR repository URL from Step 1)
git remote add origin https://github.com/KhashayarBoush/es-kibana-project.git

# Set branch to main
git branch -M main

# Push to GitHub
git push -u origin main
```

### What happens:
- Git will prompt you to log into GitHub
- A browser window may open to authenticate
- Your project will be uploaded to GitHub
- You'll see the progress of files being pushed

---

## STEP 5: Verify on GitHub

1. Refresh your GitHub repository page
2. You should see all your files:
   - ✓ Docker/ folder (with all scripts)
   - ✓ docs/, src/, tests/ folders
   - ✓ index.js, package.json, README.md
   - ✓ system-info-monitor.ps1
   - ✓ DOCKER_CLEANUP_SUMMARY.md
   - ✓ All setup guides

---

## Complete PowerShell Script (All-in-One)

Save this as `github-push-complete.ps1`:

```powershell
#!/usr/bin/env pwsh

# GitHub Push - Complete Automation
# Usage: .\github-push-complete.ps1 -RepoUrl "YOUR_REPO_URL"

param(
    [Parameter(Mandatory=$true)]
    [string]$RepoUrl = "",
    
    [Parameter(Mandatory=$false)]
    [string]$ProjectPath = "D:\Khashayar\Vscode\XXVI"
)

Write-Host "`n╔════════════════════════════════════════════════════════════╗"
Write-Host "║       GitHub Push - Complete Automation Script            ║"
Write-Host "╚════════════════════════════════════════════════════════════╝`n" -ForegroundColor Magenta

if (-not $RepoUrl) {
    Write-Host "ERROR: Repository URL is required!" -ForegroundColor Red
    Write-Host "`nUsage:`n.\github-push-complete.ps1 -RepoUrl 'https://github.com/username/es-kibana-project.git'" -ForegroundColor Yellow
    exit 1
}

# Check Git
Write-Host "▶ Checking Git installation..." -ForegroundColor Cyan
try {
    $gitVersion = & git --version
    Write-Host "[OK] $gitVersion" -ForegroundColor Green
} catch {
    Write-Host "[ERROR] Git not installed. Please install from: https://git-scm.com/download/win" -ForegroundColor Red
    exit 1
}

# Check project path
Write-Host "`n▶ Checking project path..." -ForegroundColor Cyan
if (Test-Path $ProjectPath) {
    Write-Host "[OK] Project found at: $ProjectPath" -ForegroundColor Green
} else {
    Write-Host "[ERROR] Project path not found: $ProjectPath" -ForegroundColor Red
    exit 1
}

# Navigate to project
Set-Location $ProjectPath
Write-Host "`n▶ Working directory: $(Get-Location)" -ForegroundColor Cyan

# Initialize Git
Write-Host "`n▶ Initializing Git repository..." -ForegroundColor Cyan
git init
Write-Host "[OK] Git initialized" -ForegroundColor Green

# Configure Git
Write-Host "`n▶ Configuring Git..." -ForegroundColor Cyan
$userName = git config user.name
$userEmail = git config user.email

if (-not $userName) {
    $userName = "Khashayar Boush"
    git config --global user.name $userName
}
if (-not $userEmail) {
    $userEmail = Read-Host "Enter your email"
    git config --global user.email $userEmail
}
Write-Host "[OK] Configured as: $userName <$userEmail>" -ForegroundColor Green

# Add files
Write-Host "`n▶ Adding files..." -ForegroundColor Cyan
git add .
$fileCount = & git ls-files | Measure-Object -Line
Write-Host "[OK] Added $($fileCount.Lines) files" -ForegroundColor Green

# Commit
Write-Host "`n▶ Creating commit..." -ForegroundColor Cyan
git commit -m "Initial commit: ELK Stack with Elasticsearch + Kibana Docker setup, FortiGate attack logs, and Docker management scripts"
Write-Host "[OK] Commit created" -ForegroundColor Green

# Add remote
Write-Host "`n▶ Adding remote repository..." -ForegroundColor Cyan
$existing = git remote get-url origin 2>$null
if ($existing) {
    Write-Host "[INFO] Remote already exists, removing..." -ForegroundColor Yellow
    git remote remove origin
}
git remote add origin $RepoUrl
Write-Host "[OK] Remote added: $RepoUrl" -ForegroundColor Green

# Set branch
Write-Host "`n▶ Setting branch to main..." -ForegroundColor Cyan
git branch -M main
Write-Host "[OK] Branch set to main" -ForegroundColor Green

# Push
Write-Host "`n▶ Pushing to GitHub..." -ForegroundColor Cyan
git push -u origin main

Write-Host "`n╔════════════════════════════════════════════════════════════╗"
Write-Host "║              SUCCESS - Project Pushed!                    ║"
Write-Host "╚════════════════════════════════════════════════════════════╝`n" -ForegroundColor Green

Write-Host "Repository: $RepoUrl" -ForegroundColor Cyan
Write-Host "Branch: main" -ForegroundColor Cyan
Write-Host "`nVerify at: $($RepoUrl -replace '.git','')" -ForegroundColor Cyan
Write-Host "`n"
```

### Usage:
```powershell
cd D:\Khashayar\Vscode\XXVI
.\github-push-complete.ps1 -RepoUrl "https://github.com/KhashayarBoush/es-kibana-project.git"
```

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| "Command not found: git" | Install Git from git-scm.com/download/win |
| "fatal: not a git repository" | Run: `git init` |
| "error: remote origin already exists" | Run: `git remote remove origin` |
| "Permission denied (publickey)" | Use HTTPS instead of SSH |
| "fatal: Could not read from remote repository" | Check your repository URL |
| "fatal: your current branch is behind" | Run: `git pull origin main` first |

---

## After Push - Future Updates

To update your repository after making changes:

```powershell
cd "D:\Khashayar\Vscode\XXVI"
git add .
git commit -m "Description of changes"
git push
```

---

## Summary

✓ **Repository Name:** es-kibana-project  
✓ **Owner:** KhashayarBoush  
✓ **URL:** https://github.com/KhashayarBoush/es-kibana-project  
✓ **Branch:** main  
✓ **Files:** ~15 files + Docker folder + subdirectories  

**Next Step:** Create the repository manually at https://github.com/new, then run the PowerShell script with your repository URL.

