# GitHub Setup & Push Guide

## Part 1: Create GitHub Repository

1. **Go to GitHub:**
   - Visit https://github.com/login and sign in
   - Click the **"+"** icon (top right)
   - Select **"New repository"**

2. **Create Repository Settings:**
   - **Repository name:** `es-kibana-project` (or `es-kibana`)
   - **Description:** "Elasticsearch + Kibana Docker Stack with ELK Setup"
   - **Visibility:** Public or Private (your choice)
   - **Initialize with:** 
     - ❌ DO NOT check "Add a README"
     - ❌ DO NOT check "Add .gitignore"
     - ❌ DO NOT check "Add license"
   - Click **"Create repository"**

3. **Copy the Repository URL:**
   - You'll see a page with your repo URL
   - Click the green "Code" button
   - Copy the URL (looks like: `https://github.com/YOUR_USERNAME/es-kibana-project.git`)
   - Keep this URL for the next steps

---

## Part 2: Configure Git (First Time Only)

Run these commands in PowerShell:

```powershell
# Set your Git username and email
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Optional: Set default branch to main
git config --global init.defaultBranch main
```

---

## Part 3: Initialize Local Repository & Push

Navigate to your project directory and run:

```powershell
cd D:\Khashayar\Vscode\XXVI

# Initialize git repository
git init

# Add all files
git add .

# Create initial commit
git commit -m "Initial commit: ELK Stack with Elasticsearch + Kibana Docker setup, FortiGate attack logs, and Docker management scripts"

# Add remote repository (replace with YOUR URL from Step 1)
git remote add origin https://github.com/YOUR_USERNAME/es-kibana-project.git

# Push to GitHub
git branch -M main
git push -u origin main
```

---

## Part 4: Verify on GitHub

1. Refresh your GitHub repository page
2. You should see all your files:
   - Docker/ (folder with all scripts)
   - index.js
   - package.json
   - README.md
   - system-info-monitor.ps1
   - system.info
   - DOCKER_CLEANUP_SUMMARY.md
   - docs/, src/, tests/ (if they exist)

---

## Quick Reference: Git Commands

```powershell
# Check status
git status

# See what files will be committed
git diff --cached

# Commit with message
git commit -m "Your message here"

# Push to GitHub
git push

# View commit history
git log --oneline

# Add only specific files
git add path/to/file.ps1
git commit -m "Update: description"
git push
```

---

## Authentication Options

### Option A: HTTPS (Recommended for beginners)
- You'll be prompted for username/password
- On Windows, PowerShell will show a login dialog

### Option B: SSH (More secure)
1. Generate SSH key:
   ```powershell
   ssh-keygen -t rsa -b 4096 -C "your.email@example.com"
   ```
2. Add public key to GitHub settings
3. Use SSH URL: `git@github.com:YOUR_USERNAME/es-kibana-project.git`

---

## Troubleshooting

### "fatal: not a git repository"
```powershell
git init
```

### "Permission denied (publickey)"
- Use HTTPS instead of SSH
- Or setup SSH keys on GitHub

### "error: The requested URL returned error: 401 Unauthorized"
- Check your GitHub credentials
- Regenerate personal access token if needed

### "error: remote origin already exists"
```powershell
git remote remove origin
git remote add origin https://github.com/YOUR_USERNAME/es-kibana-project.git
```

---

## File Structure That Will Be Pushed

```
es-kibana-project/
├── Docker/
│   ├── manage-docker.ps1           (Master control script)
│   ├── MANAGEMENT_GUIDE.md         (Usage documentation)
│   ├── QUICK_REFERENCE.md          (Command cheat sheet)
│   ├── docker-elk.yml              (ELK configuration)
│   ├── docker-compose.yml          (Debian configuration)
│   ├── Dockerfile                  (Debian build file)
│   └── README.md                   (Docker documentation)
├── docs/                           (Project documentation)
├── src/                            (Source code)
├── tests/                          (Test files)
├── index.js                        (Main file)
├── package.json                    (Dependencies)
├── README.md                       (Project readme)
├── system-info-monitor.ps1         (System monitoring script)
├── system.info                     (System information)
└── DOCKER_CLEANUP_SUMMARY.md       (Setup summary)
```

---

## After Installation - Automated Script

Once Git is installed, you can run this PowerShell script to automate the process:

```powershell
# Save as: github-push.ps1
param(
    [string]$GitHubUrl = "",
    [string]$CommitMessage = "Initial commit: ELK Stack with Elasticsearch + Kibana"
)

if (-not $GitHubUrl) {
    Write-Host "Please provide GitHub URL:"
    Write-Host "Example: https://github.com/username/es-kibana-project.git"
    $GitHubUrl = Read-Host "GitHub URL"
}

cd "D:\Khashayar\Vscode\XXVI"

Write-Host "Initializing git repository..." -ForegroundColor Cyan
git init

Write-Host "Adding all files..." -ForegroundColor Cyan
git add .

Write-Host "Creating commit..." -ForegroundColor Cyan
git commit -m $CommitMessage

Write-Host "Adding remote..." -ForegroundColor Cyan
git remote add origin $GitHubUrl

Write-Host "Renaming branch to main..." -ForegroundColor Cyan
git branch -M main

Write-Host "Pushing to GitHub..." -ForegroundColor Cyan
git push -u origin main

Write-Host "✓ Successfully pushed to GitHub!" -ForegroundColor Green
Write-Host "Repository: $GitHubUrl" -ForegroundColor Green
```

---

**Ready to get started?**

1. Install Git from: https://git-scm.com/download/win
2. Create GitHub repository at: https://github.com/new
3. Come back and we'll push together!

