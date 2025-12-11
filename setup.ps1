# Deployment Setup Script
# Run this script to complete the deployment setup

Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "  Terraform CI/CD Pipeline - Deployment Setup" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Configure Git User
Write-Host "Step 1: Configure Git User" -ForegroundColor Yellow
Write-Host "----------------------------" -ForegroundColor Yellow
$gitUserName = Read-Host "Enter your Git username (e.g., John Doe)"
$gitUserEmail = Read-Host "Enter your Git email (e.g., john@example.com)"

git config --global user.name "$gitUserName"
git config --global user.email "$gitUserEmail"
Write-Host "✓ Git user configured" -ForegroundColor Green
Write-Host ""

# Step 2: Commit Files
Write-Host "Step 2: Commit Files" -ForegroundColor Yellow
Write-Host "--------------------" -ForegroundColor Yellow
git commit -m "Initial Terraform CI/CD setup with GitHub Actions"
Write-Host "✓ Files committed" -ForegroundColor Green
Write-Host ""

# Step 3: Rename Branch to Main
Write-Host "Step 3: Rename Branch to Main" -ForegroundColor Yellow
Write-Host "------------------------------" -ForegroundColor Yellow
git branch -M main
Write-Host "✓ Branch renamed to main" -ForegroundColor Green
Write-Host ""

# Step 4: Add GitHub Remote
Write-Host "Step 4: Add GitHub Remote" -ForegroundColor Yellow
Write-Host "-------------------------" -ForegroundColor Yellow
Write-Host ""
Write-Host "IMPORTANT: Create a new repository on GitHub first!" -ForegroundColor Red
Write-Host "1. Go to https://github.com/new" -ForegroundColor White
Write-Host "2. Create a new repository (e.g., 'terraform-aws-pipeline')" -ForegroundColor White
Write-Host "3. Do NOT initialize with README, .gitignore, or license" -ForegroundColor White
Write-Host ""
$repoUrl = Read-Host "Enter your GitHub repository URL (e.g., https://github.com/username/repo.git)"

git remote add origin $repoUrl
Write-Host "✓ Remote added" -ForegroundColor Green
Write-Host ""

# Step 5: Push to GitHub
Write-Host "Step 5: Push to GitHub" -ForegroundColor Yellow
Write-Host "----------------------" -ForegroundColor Yellow
Write-Host "Pushing code to GitHub..." -ForegroundColor White
git push -u origin main
Write-Host "✓ Code pushed to GitHub" -ForegroundColor Green
Write-Host ""

# Step 6: Configure GitHub Secrets
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "  NEXT STEP: Configure GitHub Secrets" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "To complete the setup, you need to add AWS credentials to GitHub:" -ForegroundColor Yellow
Write-Host ""
Write-Host "1. Go to your GitHub repository" -ForegroundColor White
Write-Host "2. Click on 'Settings' tab" -ForegroundColor White
Write-Host "3. Navigate to 'Secrets and variables' → 'Actions'" -ForegroundColor White
Write-Host "4. Click 'New repository secret'" -ForegroundColor White
Write-Host "5. Add the following secrets:" -ForegroundColor White
Write-Host ""
Write-Host "   Secret 1:" -ForegroundColor Cyan
Write-Host "   Name: AWS_ACCESS_KEY_ID" -ForegroundColor White
Write-Host "   Value: Your AWS access key ID" -ForegroundColor White
Write-Host ""
Write-Host "   Secret 2:" -ForegroundColor Cyan
Write-Host "   Name: AWS_SECRET_ACCESS_KEY" -ForegroundColor White
Write-Host "   Value: Your AWS secret access key" -ForegroundColor White
Write-Host ""
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "  After adding secrets, trigger deployment:" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Run this command to trigger the pipeline:" -ForegroundColor Yellow
Write-Host "  git commit --allow-empty -m 'Deploy infrastructure'" -ForegroundColor White
Write-Host "  git push" -ForegroundColor White
Write-Host ""
Write-Host "Then go to the 'Actions' tab in GitHub to watch the deployment!" -ForegroundColor Green
Write-Host ""
