# SecureBank Payment Infrastructure

This Terraform project deploys a complete AWS infrastructure for the SecureBank Payment application, following HashiCorp best practices.

## 🏗️ Architecture

The infrastructure includes:
- **VPC** with public and private subnets across multiple AZs
- **EC2 Instance** hosting the .NET 8 SPA application
- **DynamoDB Table** for data storage
- **Security Groups** and **IAM Roles** for security
- **CloudWatch** monitoring and logging
- **S3 Backend** for Terraform state management

## 📁 Project Structure

```
terraform/
├── 📋 main.tf                    # Root module configuration
├── 📝 variables.tf               # Input variables
├── 📤 outputs.tf                 # Output values
├── 🧩 modules/                   # Reusable modules
│   ├── vpc/                     # VPC, subnets, routing
│   ├── security/                # Security groups, IAM roles
│   ├── ec2/                     # EC2 instance, monitoring
│   └── dynamodb/                # DynamoDB table, backup
├── 🌍 environments/              # Environment-specific configs
│   ├── dev/                     # Development environment
│   └── prod/                    # Production environment
├── 📜 policies/                  # Terraform Sentinel policies
│   ├── aws-instance-type.sentinel
│   ├── aws-tagging.sentinel
│   └── aws-security.sentinel
├── 🛠️ scripts/                   # Deployment scripts
│   ├── user_data.sh             # EC2 bootstrap script
│   └── validate-structure.sh    # Validation script
└── 📖 README.md                  # This file
```

## 🚀 Prerequisites

1. **Terraform** v1.12.2 or later
2. **AWS CLI** configured with appropriate credentials
3. **HashiCorp Cloud Platform (HCP) Terraform** account and organization
4. **EC2 Key Pairs** for SSH access

## 🛠️ Setup

### 1. Configure HCP Terraform Backend

#### Create HCP Organization and Workspaces

1. **Sign up for HCP Terraform** at https://app.terraform.io
2. **Create an organization** named `securebank-payment`
3. **Create workspaces** for each environment:
   - `securebank-payment-dev` (Development)
   - `securebank-payment-prod` (Production)

#### Configure Terraform CLI

```bash
# Login to HCP Terraform
terraform login

# Verify your authentication
terraform version
```

#### Workspace Configuration

Each workspace should be configured with:
- **Execution Mode**: Remote
- **Terraform Version**: 1.12.2
- **VCS Connection**: Connect to your Git repository (optional)
- **Variables**: Configure environment-specific variables

### 2. Create EC2 Key Pairs

```bash
# Development key pair
aws ec2 create-key-pair --key-name securebank-key-dev --query 'KeyMaterial' --output text > ~/.ssh/securebank-key-dev.pem
chmod 400 ~/.ssh/securebank-key-dev.pem

# Production key pair
aws ec2 create-key-pair --key-name securebank-key-prod --query 'KeyMaterial' --output text > ~/.ssh/securebank-key-prod.pem
chmod 400 ~/.ssh/securebank-key-prod.pem
```

## 🚀 Deployment

### Development Environment

```bash
cd environments/dev
terraform init
terraform plan
terraform apply
```

**Note**: With HCP Terraform, you can also trigger runs through the web UI or API.

### Production Environment

```bash
cd environments/prod
terraform init
terraform plan
terraform apply
```

**Note**: For production, consider using HCP Terraform's approval workflows and policy enforcement.

## ⚙️ Configuration

### Environment Variables

| Variable | Description | Dev Default | Prod Default |
|----------|-------------|-------------|--------------|
| `environment` | Environment name | `dev` | `prod` |
| `instance_type` | EC2 instance type | `t3.small` | `t3.medium` |
| `key_name` | EC2 key pair name | `securebank-key-dev` | `securebank-key-prod` |
| `dynamodb_billing_mode` | DynamoDB billing mode | `PAY_PER_REQUEST` | `PROVISIONED` |

### Module Configuration

Each module can be configured independently:

- **VPC Module**: CIDR blocks, subnet configuration
- **Security Module**: Security group rules, IAM policies
- **EC2 Module**: Instance type, AMI, user data
- **DynamoDB Module**: Table schema, backup configuration

## 🔒 Security

### Security Groups
- **Application SG**: HTTP (80), HTTPS (443), App Port (5000)
- **Database SG**: DynamoDB access from application

### IAM Roles
- **EC2 Role**: CloudWatch Logs, DynamoDB access
- **Least Privilege**: Minimal required permissions

### Encryption
- **EBS Volumes**: Encrypted at rest
- **DynamoDB**: Server-side encryption enabled
- **S3 Backend**: Encryption enabled

## 📊 Monitoring

### CloudWatch
- **Logs**: Application and system logs
- **Metrics**: CPU, memory, disk usage
- **Dashboard**: Real-time monitoring

### Alarms
- High CPU utilization
- Memory usage thresholds
- Disk space monitoring

## 🧪 Testing

### Validation

```bash
# Validate project structure
./scripts/validate-structure.sh

# Format code
terraform fmt -recursive

# Validate syntax
terraform validate
```

### Sentinel Policies

The project includes three Sentinel policies that can be enforced through HCP Terraform:

1. **Instance Type Policy**: Restricts EC2 instance types for cost control
2. **Tagging Policy**: Enforces required tags on resources
3. **Security Policy**: Prevents overly permissive security group rules

#### Policy Enforcement

To enable policy enforcement in HCP Terraform:
1. Navigate to your organization settings
2. Go to "Policies" section
3. Upload the Sentinel policies from the `policies/` directory
4. Configure policy enforcement levels (soft-mandatory, hard-mandatory)

## 🧹 Cleanup

### Destroy Infrastructure

```bash
# Development
cd environments/dev
terraform destroy

# Production
cd environments/prod
terraform destroy
```

### Clean Up Resources

```bash
# Delete key pairs
aws ec2 delete-key-pair --key-name securebank-key-dev
aws ec2 delete-key-pair --key-name securebank-key-prod
```

**Note**: HCP Terraform workspaces and state will be managed through the HCP Terraform UI.

## 📤 Outputs

After deployment, you'll get:

- **VPC ID**: Network infrastructure identifier
- **Subnet IDs**: Public and private subnet identifiers
- **EC2 Instance ID**: Application server identifier
- **Public IP**: Application server public IP
- **Application URL**: Direct link to the application
- **DynamoDB Table**: Database table name and ARN
- **SSH Command**: Pre-formatted SSH connection command

## 🔄 CI/CD Integration

### GitHub Actions Example

```yaml
name: Deploy Infrastructure
on:
  push:
    branches: [main, develop]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: hashicorp/setup-terraform@v2
        with:
          terraform_version: 1.12.2
      - name: Deploy Dev
        if: github.ref == 'refs/heads/develop'
        run: |
          cd terraform/environments/dev
          terraform init
          terraform plan
          # Note: terraform apply will be handled by HCP Terraform
      - name: Deploy Prod
        if: github.ref == 'refs/heads/main'
        run: |
          cd terraform/environments/prod
          terraform init
          terraform plan
          # Note: terraform apply will be handled by HCP Terraform
```

### HCP Terraform VCS Integration

For better integration, connect your Git repository to HCP Terraform:
1. In your HCP Terraform organization, go to "Settings" > "VCS"
2. Connect your Git provider (GitHub, GitLab, etc.)
3. Configure workspace to use VCS-driven workflow
4. Terraform runs will be automatically triggered on code changes

## 🐛 Troubleshooting

### Common Issues

1. **State Lock**: If Terraform state is locked, check for running operations in HCP Terraform
2. **Provider Issues**: Ensure AWS credentials are properly configured
3. **Network Issues**: Verify VPC and subnet configurations
4. **Permission Errors**: Check IAM roles and policies
5. **HCP Authentication**: Ensure you're logged in with `terraform login`
6. **Workspace Access**: Verify you have access to the required workspaces

### Debug Commands

```bash
# Check Terraform state
terraform show

# List resources
terraform state list

# Import existing resources
terraform import aws_instance.app_server i-1234567890abcdef0

# Refresh state
terraform refresh
```

## 📞 Support

For issues and questions:
1. Check the troubleshooting section
2. Review Terraform logs
3. Consult AWS documentation
4. Contact the infrastructure team

## 📄 License

This project is licensed under the MIT License.
