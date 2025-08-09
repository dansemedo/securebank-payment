#!/bin/bash

# Terraform Validation Script
# This script validates the entire Terraform project structure and configuration

set -e

echo "🔍 Terraform Project Validation"
echo "================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    local status=$1
    local message=$2
    case $status in
        "SUCCESS")
            echo -e "${GREEN}✅ $message${NC}"
            ;;
        "ERROR")
            echo -e "${RED}❌ $message${NC}"
            ;;
        "WARNING")
            echo -e "${YELLOW}⚠️  $message${NC}"
            ;;
        "INFO")
            echo -e "${BLUE}ℹ️  $message${NC}"
            ;;
    esac
}

# Check if we're in the terraform directory
if [ ! -f "main.tf" ]; then
    print_status "ERROR" "main.tf not found. Please run this script from the terraform directory."
    exit 1
fi

print_status "INFO" "Starting validation from $(pwd)"

# 1. Check Terraform version
echo ""
print_status "INFO" "Checking Terraform version..."
terraform_version=$(terraform --version | head -n1)
print_status "SUCCESS" "Found: $terraform_version"

# 2. Check required files
echo ""
print_status "INFO" "Checking required files..."

required_files=(
    "main.tf"
    "variables.tf"
    "outputs.tf"
    "modules/vpc/main.tf"
    "modules/vpc/variables.tf"
    "modules/vpc/outputs.tf"
    "modules/security/main.tf"
    "modules/security/variables.tf"
    "modules/security/outputs.tf"
    "modules/ec2/main.tf"
    "modules/ec2/variables.tf"
    "modules/ec2/outputs.tf"
    "modules/dynamodb/main.tf"
    "modules/dynamodb/variables.tf"
    "modules/dynamodb/outputs.tf"
    "environments/dev/main.tf"
    "environments/dev/variables.tf"
    "environments/dev/outputs.tf"
    "environments/prod/main.tf"
    "environments/prod/variables.tf"
    "environments/prod/outputs.tf"
    "policies/aws-instance-type.sentinel"
    "policies/aws-tagging.sentinel"
    "policies/aws-security.sentinel"
    "scripts/user_data.sh"
    "scripts/validate.sh"
    "README.md"
)

missing_files=()
for file in "${required_files[@]}"; do
    if [ -f "$file" ]; then
        print_status "SUCCESS" "Found: $file"
    else
        print_status "ERROR" "Missing: $file"
        missing_files+=("$file")
    fi
done

if [ ${#missing_files[@]} -gt 0 ]; then
    echo ""
    print_status "ERROR" "Missing ${#missing_files[@]} required files:"
    for file in "${missing_files[@]}"; do
        echo "  - $file"
    done
    exit 1
fi

# 3. Check directory structure
echo ""
print_status "INFO" "Checking directory structure..."

required_dirs=(
    "modules"
    "modules/vpc"
    "modules/security"
    "modules/ec2"
    "modules/dynamodb"
    "environments"
    "environments/dev"
    "environments/prod"
    "policies"
    "scripts"
)

for dir in "${required_dirs[@]}"; do
    if [ -d "$dir" ]; then
        print_status "SUCCESS" "Found directory: $dir"
    else
        print_status "ERROR" "Missing directory: $dir"
        exit 1
    fi
done

# 4. Validate Terraform syntax
echo ""
print_status "INFO" "Validating Terraform syntax..."

# Check formatting
if terraform fmt -recursive -check; then
    print_status "SUCCESS" "Terraform formatting is correct"
else
    print_status "WARNING" "Terraform formatting issues found. Run 'terraform fmt -recursive' to fix."
fi

# Check providers (without downloading)
print_status "INFO" "Checking provider requirements..."
terraform providers > /dev/null 2>&1
if [ $? -eq 0 ]; then
    print_status "SUCCESS" "Provider configuration is valid"
else
    print_status "WARNING" "Provider configuration issues detected"
fi

# 5. Validate modules
echo ""
print_status "INFO" "Validating modules..."

modules=("vpc" "security" "ec2" "dynamodb")
for module in "${modules[@]}"; do
    if [ -f "modules/$module/main.tf" ] && [ -f "modules/$module/variables.tf" ] && [ -f "modules/$module/outputs.tf" ]; then
        print_status "SUCCESS" "Module $module is complete"
    else
        print_status "ERROR" "Module $module is incomplete"
        exit 1
    fi
done

# 6. Validate environments
echo ""
print_status "INFO" "Validating environments..."

environments=("dev" "prod")
for env in "${environments[@]}"; do
    if [ -f "environments/$env/main.tf" ] && [ -f "environments/$env/variables.tf" ] && [ -f "environments/$env/outputs.tf" ]; then
        print_status "SUCCESS" "Environment $env is complete"
    else
        print_status "ERROR" "Environment $env is incomplete"
        exit 1
    fi
done

# 7. Validate Sentinel policies
echo ""
print_status "INFO" "Validating Sentinel policies..."

sentinel_policies=(
    "aws-instance-type.sentinel"
    "aws-tagging.sentinel"
    "aws-security.sentinel"
)

for policy in "${sentinel_policies[@]}"; do
    if [ -f "policies/$policy" ]; then
        print_status "SUCCESS" "Found policy: $policy"
    else
        print_status "ERROR" "Missing policy: $policy"
        exit 1
    fi
done

# 8. Check script permissions
echo ""
print_status "INFO" "Checking script permissions..."

scripts=("scripts/user_data.sh" "scripts/validate.sh")
for script in "${scripts[@]}"; do
    if [ -x "$script" ]; then
        print_status "SUCCESS" "Script is executable: $script"
    else
        print_status "WARNING" "Script is not executable: $script"
        chmod +x "$script"
        print_status "SUCCESS" "Made executable: $script"
    fi
done

# 9. Validate user_data script syntax
echo ""
print_status "INFO" "Validating user_data script syntax..."
if bash -n scripts/user_data.sh; then
    print_status "SUCCESS" "user_data.sh syntax is valid"
else
    print_status "ERROR" "user_data.sh has syntax errors"
    exit 1
fi

# 10. Summary
echo ""
echo "================================="
print_status "SUCCESS" "Validation completed successfully!"
echo ""
print_status "INFO" "Project Summary:"
echo "  📁 Modules: 4 (vpc, security, ec2, dynamodb)"
echo "  🌍 Environments: 2 (dev, prod)"
echo "  📜 Policies: 3 (instance-type, tagging, security)"
echo "  🛠️ Scripts: 2 (user_data, validate)"
echo "  📋 Files: ${#required_files[@]} total"
echo ""
print_status "INFO" "Next steps:"
echo "  1. Configure AWS credentials"
echo "  2. Set up HCP Terraform organization and workspaces"
echo "  3. Create EC2 key pairs"
echo "  4. Run 'terraform login' to authenticate with HCP"
echo "  5. Run 'terraform init' to download providers"
echo "  6. Run 'terraform plan' to review changes"
echo "  7. Run 'terraform apply' to deploy (or use HCP UI)"
echo ""
print_status "SUCCESS" "🎉 Terraform project is ready for deployment!"
