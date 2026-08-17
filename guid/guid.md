# Manual GitHub Push Guide

This guide explains the exact manual steps to push this project to your GitHub repository.

Repository URL:
https://github.com/KhashayarBoush/kibana-es-project.git

---

## 1) Create the GitHub repository

1. Open: https://github.com/new
2. Set repository name: `kibana-es-project`
3. Choose Public or Private
4. Do not add README, .gitignore, or license
5. Click Create repository
6. Copy the HTTPS URL from the green Code button

Example:
https://github.com/KhashayarBoush/kibana-es-project.git

---

## 2) Open PowerShell in the project folder

Run:

```powershell
cd D:\Khashayar\Vscode\XXVI
```

---

## 3) Check whether Git is installed

Run:

```powershell
git --version
```

If Git is not found, install it:

```powershell
winget install --id Git.Git -e --source winget
```

Then close and open PowerShell again.

---

## 4) Start Git in the project

If the folder is not already a Git repository, run:

```powershell
git init
```

Set your Git identity:

```powershell
git config user.name "Khashayar Boush"
git config user.email "khashayar.boush@example.com"
```

Set the branch name:

```powershell
git branch -M main
```

---

## 5) Connect the project to GitHub

If the remote does not exist:

```powershell
git remote add origin https://github.com/KhashayarBoush/kibana-es-project.git
```

If the remote already exists:

```powershell
git remote remove origin
git remote add origin https://github.com/KhashayarBoush/kibana-es-project.git
```

Check the remote:

```powershell
git remote -v
```

---

## 6) Add all files to Git

```powershell
git add .
```

---

## 7) Create the initial commit

```powershell
git commit -m "Initial commit: ELK + Kibana project"
```

If Git says there is nothing to commit, run:

```powershell
git status
```

Then verify whether the files are tracked or whether the repo is already synced.

---

## 8) Push the project to GitHub

```powershell
git push -u origin main
```

If GitHub asks for login, sign in with your browser and authorize access.

---

## 9) If the push is rejected

This usually happens when the GitHub repository already has a different initial commit.

First fetch remote changes:

```powershell
git fetch origin
```

Then either:

```powershell
git pull --rebase origin main
```

or, if you want to replace the existing remote history with your project history:

```powershell
git push --force-with-lease origin main
```

Use `--force-with-lease` only when you are sure your local project is the correct version.

---

## 10) Verify the upload on GitHub

Open:
https://github.com/KhashayarBoush/kibana-es-project

Check that your project files are visible:
- Docker/
- docs/
- src/
- tests/
- README.md
- package.json
- index.js
- all project files

---

## 11) Future updates

After each new change:

```powershell
git add .
git commit -m "Describe your changes"
git push
```

---

## Quick commands summary

```powershell
cd D:\Khashayar\Vscode\XXVI
git init
git branch -M main
git config user.name "Khashayar Boush"
git config user.email "khashayar.boush@example.com"
git remote add origin https://github.com/KhashayarBoush/kibana-es-project.git
git add .
git commit -m "Initial commit: ELK + Kibana project"
git push -u origin main
```

If the remote already contains data:

```powershell
git fetch origin
git push --force-with-lease origin main
```
