# Manual Setup Instructions

If you prefer to run commands manually instead of using the setup script:

## 1. Configure Git User
```powershell
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

## 2. Commit Files
```powershell
git commit -m "Initial Terraform CI/CD setup with GitHub Actions"
```

## 3. Rename Branch to Main
```powershell
git branch -M main
```

## 4. Create GitHub Repository
1. Go to https://github.com/new
2. Create a new repository (e.g., "terraform-aws-pipeline")
3. Do NOT initialize with README, .gitignore, or license
4. Copy the repository URL

## 5. Add Remote and Push
```powershell
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git
git push -u origin main
```

## 6. Configure GitHub Secrets
1. Go to your GitHub repository
2. Click **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Add these secrets:
   - Name: `AWS_ACCESS_KEY_ID` → Value: Your AWS access key
   - Name: `AWS_SECRET_ACCESS_KEY` → Value: Your AWS secret key

## 7. Trigger Deployment
```powershell
git commit --allow-empty -m "Deploy infrastructure"
git push
```

## 8. Monitor Deployment
1. Go to **Actions** tab in GitHub
2. Watch the workflow execute
3. Get the website URL from the job summary
