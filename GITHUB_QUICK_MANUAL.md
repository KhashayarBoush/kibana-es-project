# GitHub Push - Quick Manual

## Prerequisites ✓
- [ ] Git installed (https://git-scm.com/download/win)
- [ ] GitHub account (https://github.com/signup)
- [ ] Repository created (https://github.com/new)
- [ ] Repository URL copied

---

## Method 1: Use Automated Script (RECOMMENDED)

### Step 1: Install Git
1. Download from: https://git-scm.com/download/win
2. Run installer → Accept all defaults → Restart PowerShell

### Step 2: Create GitHub Repository
1. Go to: https://github.com/new
2. Name: `es-kibana-project`
3. Click Create
4. Copy the HTTPS URL (green "Code" button)

### Step 3: Run the Script
```powershell
cd D:\Khashayar\Vscode\XXVI
.\github-setup.ps1 -GitHubUrl "https://github.com/YOUR_USERNAME/es-kibana-project.git"
```

**Done!** Your project is on GitHub ✓

---

## Method 2: Manual Commands

If you prefer to run commands manually:

```powershell
cd D:\Khashayar\Vscode\XXVI

# Initialize git
git init

# Configure git (first time only)
git config --global user.name "Your Name"
git config --global user.email "your@email.com"

# Add all files
git add .

# Commit
git commit -m "Initial commit: ELK Stack with Elasticsearch + Kibana Docker setup"

# Add GitHub remote
git remote add origin https://github.com/YOUR_USERNAME/es-kibana-project.git

# Set main branch
git branch -M main

# Push to GitHub
git push -u origin main
```

---

## Verify on GitHub

1. Go to your repository: `https://github.com/YOUR_USERNAME/es-kibana-project`
2. Refresh the page
3. You should see all your files:
   - Docker/ folder
   - source files
   - All documentation

---

## After Push - Useful Commands

```powershell
# Check status
git status

# See commit history
git log --oneline

# Update existing files and push
git add .
git commit -m "Your message"
git push
```

---

## Troubleshooting

| Problem | Solution |
|---------|----------|
| "Command not found: git" | Install Git from git-scm.com/download/win |
| "No such file or directory" | Make sure you're in the correct directory |
| "Permission denied" | Check GitHub URL and credentials |
| "error: remote already exists" | Run: `git remote remove origin` first |
| "fatal: not a git repository" | Run: `git init` first |

---

## GitHub Repository Information

```
Repository Name:  es-kibana-project
Location:         https://github.com/YOUR_USERNAME/es-kibana-project
Default Branch:   main
Description:      Elasticsearch + Kibana Docker Stack with ELK Setup
Visibility:       Public/Private (your choice)
```

---

## What Gets Pushed

```
es-kibana-project/
├── Docker/
│   ├── manage-docker.ps1          [MAIN SCRIPT]
│   ├── MANAGEMENT_GUIDE.md
│   ├── QUICK_REFERENCE.md
│   ├── docker-elk.yml
│   ├── docker-compose.yml
│   ├── Dockerfile
│   └── README.md
├── docs/
├── src/
├── tests/
├── index.js
├── package.json
├── README.md
├── system-info-monitor.ps1
├── system.info
├── DOCKER_CLEANUP_SUMMARY.md
├── GITHUB_SETUP_GUIDE.md
└── github-setup.ps1
```

---

## Quick Links

- 📥 Download Git: https://git-scm.com/download/win
- 🔧 Create Repository: https://github.com/new
- 📚 Git Documentation: https://git-scm.com/doc
- ❓ GitHub Help: https://docs.github.com/

---

## Important Notes

✓ **Repository Name:** Use `es-kibana-project` for consistency  
✓ **Default Branch:** Should be `main` (not master)  
✓ **Authentication:** GitHub will prompt you to sign in on first push  
✓ **Email Privacy:** GitHub can hide your email from commit history  
✓ **Initial Push:** Takes longer first time (subsequent pushes are faster)  

---

**Project Ready:** Your entire project is now version controlled and backed up on GitHub! 🎉
