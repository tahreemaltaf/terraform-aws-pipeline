# Cleanup Script - Run this to fix the duplicate resource errors

Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "  Terraform Cleanup - Fixing Duplicate Resources" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "The pipeline failed because resources were partially created." -ForegroundColor Yellow
Write-Host "We need to clean them up manually from AWS Console." -ForegroundColor Yellow
Write-Host ""

Write-Host "OPTION 1: Manual Cleanup (Recommended)" -ForegroundColor Green
Write-Host "----------------------------------------" -ForegroundColor Green
Write-Host "1. Go to AWS Console: https://ap-south-1.console.aws.amazon.com/ec2" -ForegroundColor White
Write-Host "2. Delete these resources if they exist:" -ForegroundColor White
Write-Host "   - Security Group: 'terraform-web-server-web-sg'" -ForegroundColor White
Write-Host "   - EC2 Instance: 'terraform-web-server-instance' (if any)" -ForegroundColor White
Write-Host ""
Write-Host "Steps:" -ForegroundColor Cyan
Write-Host "  a) Go to EC2 → Instances → Select any 'terraform-web-server-instance' → Terminate" -ForegroundColor White
Write-Host "  b) Go to EC2 → Security Groups → Select 'terraform-web-server-web-sg' → Delete" -ForegroundColor White
Write-Host ""

Write-Host "OPTION 2: Use Terraform Locally (Advanced)" -ForegroundColor Green
Write-Host "-------------------------------------------" -ForegroundColor Green
Write-Host "Run these commands:" -ForegroundColor White
Write-Host "  cd c:\Users\HP\Desktop\teraform" -ForegroundColor Cyan
Write-Host "  terraform destroy -auto-approve" -ForegroundColor Cyan
Write-Host ""

Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "After cleanup, trigger a new deployment:" -ForegroundColor Yellow
Write-Host "  git commit --allow-empty -m 'Redeploy after cleanup'" -ForegroundColor Cyan
Write-Host "  git push" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
