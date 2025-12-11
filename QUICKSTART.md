# Quick Start Guide - Terraform CI/CD Pipeline

## 🚀 Fast Track Deployment (5 Minutes)

### Prerequisites
- AWS Account with IAM user credentials
- GitHub account

### Step 1: Push to GitHub (2 min)
```bash
cd c:\Users\HP\Desktop\teraform
git init
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git
git push -u origin main
```

### Step 2: Configure Secrets (1 min)
1. Go to GitHub repo → **Settings** → **Secrets and variables** → **Actions**
2. Click **New repository secret**
3. Add:
   - Name: `AWS_ACCESS_KEY_ID` → Value: Your AWS access key
   - Name: `AWS_SECRET_ACCESS_KEY` → Value: Your AWS secret key

### Step 3: Deploy (1 min)
```bash
git commit --allow-empty -m "Deploy infrastructure"
git push
```

### Step 4: Access Website (1 min)
1. Go to **Actions** tab in GitHub
2. Click on the running workflow
3. Wait for completion (~3-5 minutes)
4. Find website URL in job summary
5. Click the URL to see your live website!

## 📋 What You Get

✅ EC2 instance running Ubuntu 22.04 LTS  
✅ Nginx web server serving a beautiful website  
✅ Security groups configured (HTTP, HTTPS, SSH)  
✅ Automatic deployment on every push  
✅ Idempotent infrastructure (safe to run multiple times)  

## 🔧 Common Customizations

### Restrict SSH Access
Edit `terraform.tfvars`:
```hcl
ssh_cidr_blocks = ["YOUR_IP/32"]
```

### Add SSH Key
Edit `terraform.tfvars`:
```hcl
key_name = "your-key-pair-name"
```

### Change Instance Type
Edit `terraform.tfvars`:
```hcl
instance_type = "t2.small"  # or t3.micro, etc.
```

## 📖 Full Documentation
See [README.md](file:///c:/Users/HP/Desktop/teraform/README.md) for complete documentation.

## 🎯 Next Push = Automatic Deployment
Every time you push to main/master, the pipeline automatically:
1. Validates your Terraform code
2. Plans the changes
3. Applies the infrastructure
4. Shows you the website URL

**That's it! Your infrastructure is now fully automated.** 🎉
