# HCP Terraform Setup Guide

This guide will help you set up HashiCorp Cloud Platform (HCP) Terraform for the SecureBank Payment infrastructure project.

## 🚀 Quick Start

### 1. Create HCP Terraform Account

1. Go to [HCP Terraform](https://app.terraform.io)
2. Sign up for a free account
3. Verify your email address

### 2. Create Organization

1. Click "Create organization"
2. Name: `securebank-payment`
3. Email: Your email address
4. Click "Create organization"

### 3. Create Workspaces

#### Development Workspace
1. Click "New workspace"
2. **Workspace name**: `securebank-payment-dev`
3. **Execution mode**: Remote
4. **Terraform version**: 1.12.2
5. Click "Create workspace"

#### Production Workspace
1. Click "New workspace"
2. **Workspace name**: `securebank-payment-prod`
3. **Execution mode**: Remote
4. **Terraform version**: 1.12.2
5. Click "Create workspace"

### 4. Configure VCS Integration (Optional)

1. Go to Organization Settings > VCS
2. Connect your Git provider (GitHub, GitLab, etc.)
3. In each workspace, go to Settings > General
4. Set **VCS Repository** to your repository
5. Set **VCS Branch** to `main` (or your preferred branch)
6. Set **Terraform Working Directory** to `terraform/environments/dev` or `terraform/environments/prod`

### 5. Configure Variables

#### Development Workspace Variables
Go to `securebank-payment-dev` workspace > Variables:

**Terraform Variables:**
```
environment = "dev"
instance_type = "t2.small"
key_name = "securebank-key-dev"
dynamodb_billing_mode = "PAY_PER_REQUEST"
```

**Environment Variables:**
```
AWS_ACCESS_KEY_ID = "your-aws-access-key"
AWS_SECRET_ACCESS_KEY = "your-aws-secret-key"
AWS_DEFAULT_REGION = "us-east-1"
```

#### Production Workspace Variables
Go to `securebank-payment-prod` workspace > Variables:

**Terraform Variables:**
```
environment = "prod"
instance_type = "t2.small"
key_name = "securebank-key-prod"
dynamodb_billing_mode = "PROVISIONED"
```

**Environment Variables:**
```
AWS_ACCESS_KEY_ID = "your-aws-access-key"
AWS_SECRET_ACCESS_KEY = "your-aws-secret-key"
AWS_DEFAULT_REGION = "us-east-1"
```

### 6. Configure Sentinel Policies

1. Go to Organization Settings > Policies
2. Click "Create Policy"
3. Upload the policies from the `policies/` directory:

#### Instance Type Policy
- **Name**: `aws-instance-type`
- **Enforcement Level**: Soft-mandatory
- **Policy File**: `policies/aws-instance-type.sentinel`

#### Tagging Policy
- **Name**: `aws-tagging`
- **Enforcement Level**: Soft-mandatory
- **Policy File**: `policies/aws-tagging.sentinel`

#### Security Policy
- **Name**: `aws-security`
- **Enforcement Level**: Hard-mandatory
- **Policy File**: `policies/aws-security.sentinel`

### 7. Local CLI Setup

```bash
# Login to HCP Terraform
terraform login

# Verify authentication
terraform version

# Test connection to workspace
cd terraform/environments/dev
terraform init
```

## 🔧 Workspace Configuration

### Development Workspace Settings

- **Auto Apply**: Disabled (manual approval)
- **Terraform Version**: 1.12.2
- **Working Directory**: `terraform/environments/dev`
- **VCS Branch**: `develop`

### Production Workspace Settings

- **Auto Apply**: Disabled (manual approval)
- **Terraform Version**: 1.12.2
- **Working Directory**: `terraform/environments/prod`
- **VCS Branch**: `main`
- **Approval Required**: Yes

## 🚀 Deployment Workflow

### Development Deployment

1. **Push to develop branch**
2. **HCP Terraform triggers plan**
3. **Review plan in HCP UI**
4. **Apply changes**

### Production Deployment

1. **Push to main branch**
2. **HCP Terraform triggers plan**
3. **Review plan in HCP UI**
4. **Request approval**
5. **Apply changes after approval**

## 📊 Monitoring and Logs

### Run History
- View all runs in the workspace
- Check plan and apply logs
- Monitor policy violations

### State Management
- View current state
- Compare state changes
- Rollback if needed

### Cost Estimation
- View cost estimates for changes
- Monitor resource usage
- Set up cost alerts

## 🔒 Security Features

### Policy Enforcement
- **Soft-mandatory**: Warns but allows override
- **Hard-mandatory**: Blocks deployment if violated
- **Advisory**: Provides guidance only

### Access Control
- **Team Management**: Add/remove team members
- **Role-based Access**: Admin, Write, Read permissions
- **SSO Integration**: Connect to your identity provider

### Audit Logs
- Track all workspace changes
- Monitor policy violations
- Review approval history

## 🐛 Troubleshooting

### Common Issues

1. **Authentication Errors**
   ```bash
   terraform login
   ```

2. **Workspace Not Found**
   - Verify workspace name matches backend configuration
   - Check organization name

3. **Policy Violations**
   - Review policy logs
   - Update infrastructure to comply
   - Request policy override if needed

4. **VCS Connection Issues**
   - Verify repository permissions
   - Check branch names
   - Ensure working directory is correct

### Support Resources

- [HCP Terraform Documentation](https://www.terraform.io/docs/cloud)
- [Sentinel Policy Language](https://docs.hashicorp.com/sentinel)
- [HCP Terraform Support](https://support.hashicorp.com)

## 📈 Best Practices

1. **Use VCS-driven workflow** for better traceability
2. **Enable policy enforcement** for compliance
3. **Require approvals** for production changes
4. **Use workspace-specific variables** for environment separation
5. **Monitor costs** and set up alerts
6. **Regular policy reviews** and updates
7. **Backup state** and configuration
8. **Document changes** and decisions
