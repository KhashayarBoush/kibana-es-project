#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Automated GitHub push script for es-kibana-project
.DESCRIPTION
    Initializes git repo, commits all files, and pushes to GitHub
.EXAMPLE
    .\github-setup.ps1 -GitHubUrl "https://github.com/username/es-kibana-project.git"
#>

param(
    [Parameter(Mandatory=$false)]
    [string]$GitHubUrl = "",
    
    [Parameter(Mandatory=$false)]
    [string]$CommitMessage = "Initial commit: ELK Stack with Elasticsearch + Kibana Docker setup, FortiGate attack logs, and management scripts",
    
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
    Write-Host "`n"
    Write-ColorOutput "==========================================================" $Colors.Header
    Write-ColorOutput "  $Title" $Colors.Header
    Write-ColorOutput "==========================================================" $Colors.Header
    Write-Host ""
}

# Verify Git is installed
Write-ColorOutput "Checking Git installation..." $Colors.Info
try {
    $gitVersion = & git --version 2>$null
    Write-ColorOutput "[OK] Git found: $gitVersion" $Colors.Success
} catch {
    Write-ColorOutput "[ERROR] Git is not installed or not in PATH" $Colors.Error
    Write-Host "
Please install Git first:
  1. Download from: https://git-scm.com/download/win
  2. Run the installer (accept all defaults)
  3. Restart PowerShell
  4. Try again
" -ForegroundColor Yellow
    exit 1
}

# Get GitHub URL if not provided
if (-not $GitHubUrl) {
    Show-Header "GitHub Repository URL Required"
    Write-Host "
To push your project to GitHub, you need:

1. A GitHub repository created at: https://github.com/new
2. Repository name: es-kibana-project
3. The HTTPS URL from your repository (green Code button)

Example URL: https://github.com/your-username/es-kibana-project.git

" -ForegroundColor Cyan
    
    $GitHubUrl = Read-Host "Enter your GitHub repository URL"
    
    if (-not $GitHubUrl) {
        Write-ColorOutput "[ERROR] No URL provided" $Colors.Error
        exit 1
    }
}

# Validate URL format
if (-not ($GitHubUrl -match "^https://github.com/.*\.git$" -or $GitHubUrl -match "^git@github.com:.*\.git$")) {
    Write-ColorOutput "[WARNING] URL format looks unusual, but continuing anyway..." $Colors.Warning
}

# Navigate to project
Write-ColorOutput "Navigating to project..." $Colors.Info
if (-not (Test-Path $ProjectPath)) {
    Write-ColorOutput "[ERROR] Project path not found: $ProjectPath" $Colors.Error
    exit 1
}
Set-Location $ProjectPath

# Check git status
if (Test-Path ".git") {
    Write-ColorOutput "[INFO] Git repository already exists" $Colors.Warning
    $reinit = Read-Host "Reinitialize? (Y/N)"
    if ($reinit -eq "Y") {
        Remove-Item ".git" -Recurse -Force
        Write-ColorOutput "[OK] Old git repo removed" $Colors.Success
    } else {
        Write-ColorOutput "[SKIP] Using existing repository" $Colors.Info
    }
}

# Initialize repository
Show-Header "Initializing Git Repository"
Write-ColorOutput ">> Running: git init" $Colors.Info
git init
Write-ColorOutput "[OK] Git initialized" $Colors.Success

# Configure git
Show-Header "Configure Git (First Time Only)"
Write-ColorOutput ">> Checking git configuration..." $Colors.Info
$gitName = git config user.name
$gitEmail = git config user.email

if (-not $gitName -or -not $gitEmail) {
    Write-Host "
Git needs your name and email for commits.
" -ForegroundColor Yellow
    
    if (-not $gitName) {
        $gitName = Read-Host "Enter your name (e.g., John Doe)"
        git config --global user.name $gitName
    }
    
    if (-not $gitEmail) {
        $gitEmail = Read-Host "Enter your email (e.g., john@example.com)"
        git config --global user.email $gitEmail
    }
}

Write-ColorOutput "[OK] Git configured as: $gitName <$gitEmail>" $Colors.Success

# Add files
Show-Header "Adding Files"
Write-ColorOutput ">> Running: git add ." $Colors.Info
git add .
$fileCount = & git ls-files | Measure-Object -Line
Write-ColorOutput "[OK] Added $($fileCount.Lines) files" $Colors.Success

# Show what will be committed
Write-Host ""
Write-ColorOutput "Files to be committed:" $Colors.Info
git diff --cached --name-only | ForEach-Object { Write-Host "  + $_" }

# Commit
Show-Header "Creating Commit"
Write-ColorOutput ">> Running: git commit -m '...'" $Colors.Info
git commit -m $CommitMessage
Write-ColorOutput "[OK] Commit created" $Colors.Success

# Add remote
Show-Header "Adding Remote Repository"
$existingRemote = git remote get-url origin 2>$null
if ($existingRemote) {
    Write-ColorOutput "[WARNING] Remote already exists: $existingRemote" $Colors.Warning
    $override = Read-Host "Override? (Y/N)"
    if ($override -eq "Y") {
        git remote remove origin
        Write-ColorOutput "[OK] Old remote removed" $Colors.Success
    } else {
        Write-ColorOutput "[SKIP] Keeping existing remote" $Colors.Info
    }
}

if (-not (git remote get-url origin 2>$null)) {
    Write-ColorOutput ">> Running: git remote add origin $GitHubUrl" $Colors.Info
    git remote add origin $GitHubUrl
    Write-ColorOutput "[OK] Remote added" $Colors.Success
}

# Set main branch
Show-Header "Setting Default Branch"
Write-ColorOutput ">> Running: git branch -M main" $Colors.Info
git branch -M main
Write-ColorOutput "[OK] Branch renamed to main" $Colors.Success

# Push to GitHub
Show-Header "Pushing to GitHub"
Write-ColorOutput ">> Running: git push -u origin main" $Colors.Info
Write-ColorOutput "[INFO] You may be prompted for credentials..." $Colors.Warning

try {
    git push -u origin main
    Write-ColorOutput "[OK] Successfully pushed to GitHub!" $Colors.Success
} catch {
    Write-ColorOutput "[ERROR] Push failed: $_" $Colors.Error
    Write-Host "
Troubleshooting:
  1. Check your GitHub URL is correct
  2. Ensure your GitHub credentials are valid
  3. Try: git push -u origin main (manually)
" -ForegroundColor Yellow
    exit 1
}

# Summary
Show-Header "Summary"
Write-Host "
Project Details:
  Name: es-kibana-project
  Location: $ProjectPath
  Remote: $GitHubUrl
  Branch: main
  Commit: $CommitMessage

GitHub Repository:
  Visit: $($GitHubUrl -replace '.git', '')
  
Next Steps:
  1. Visit your GitHub repository to verify
  2. You can now use: git add . && git commit -m 'message' && git push
  3. Share the repository URL with others
  
" -ForegroundColor Cyan

Write-ColorOutput "[OK] All done! Your project is now on GitHub!" $Colors.Success
