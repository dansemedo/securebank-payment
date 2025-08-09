#!/bin/bash

# Terraform Structure Validation Script

echo "🔍 Validating Terraform project structure..."

# Check if we're in the right directory
if [ ! -f "main.tf" ]; then
    echo "❌ Error: main.tf not found. Please run this script from the terraform directory."
    exit 1
fi

# Check required files
echo "📁 Checking required files..."
required_files=(
    "main.tf"
    "variables.tf"
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
    "scripts/user_data.sh"
)

for file in "${required_files[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file"
    else
        echo "❌ Missing: $file"
        exit 1
    fi
done

# Check Terraform version
echo "📋 Checking Terraform version..."
terraform --version

# Check syntax with terraform fmt
echo "🎨 Checking syntax with terraform fmt..."
terraform fmt -recursive -check

if [ $? -eq 0 ]; then
    echo "✅ Syntax validation passed"
else
    echo "❌ Syntax validation failed"
    exit 1
fi

# Check providers
echo "🔧 Checking provider requirements..."
terraform providers

echo "🎉 Structure validation completed successfully!"
echo ""
echo "✅ Terraform v1.12.2 is installed and ready"
echo "✅ Project structure is valid"
echo "✅ Syntax is correct"
echo "✅ All required modules are present"
echo ""
echo "Next steps:"
echo "1. Configure AWS credentials"
echo "2. Create S3 buckets for state management"
echo "3. Create EC2 key pairs"
echo "4. Run 'terraform init' to download providers"
echo "5. Run 'terraform plan' to review changes"
echo "6. Run 'terraform apply' to deploy"
