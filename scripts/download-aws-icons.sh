#!/bin/bash
# AWSアーキテクチャアイコンをダウンロードして配置するスクリプト

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
ICONS_DIR="$REPO_ROOT/plugins/aws/icons"
TMP_DIR=$(mktemp -d)

echo "Downloading AWS Architecture Icons..."

# AWS公式アイコンセットをダウンロード
ICON_URL="https://d1.awsstatic.com/onedam/marketing-channels/website/aws/en_US/architecture/approved/architecture-icons/Asset-Package_07312025.49d3aab7f9e6131e51ade8f7c6c8b961ee7d3bb1.zip"
curl -sL "$ICON_URL" -o "$TMP_DIR/aws-icons.zip"

echo "Extracting icons..."
unzip -q "$TMP_DIR/aws-icons.zip" -d "$TMP_DIR"

# サービスアイコンのディレクトリ
ARCH_DIR="$TMP_DIR/Architecture-Service-Icons_07312025"

if [ ! -d "$ARCH_DIR" ]; then
    echo "Error: Could not find Architecture-Service-Icons directory"
    rm -rf "$TMP_DIR"
    exit 1
fi

echo "Copying icons to $ICONS_DIR..."
mkdir -p "$ICONS_DIR"

copy_icon() {
    local service_id=$1
    local icon_path=$2
    local src_file="$ARCH_DIR/$icon_path"

    if [ -f "$src_file" ]; then
        cp "$src_file" "$ICONS_DIR/${service_id}.png"
        echo "  Copied: $service_id"
    else
        echo "  Warning: Not found: $service_id ($icon_path)"
    fi
}

# Compute
copy_icon "ec2" "Arch_Compute/48/Arch_Amazon-EC2_48.png"
copy_icon "lambda" "Arch_Compute/48/Arch_AWS-Lambda_48.png"
copy_icon "ecs" "Arch_Containers/48/Arch_Amazon-Elastic-Container-Service_48.png"
copy_icon "eks" "Arch_Containers/48/Arch_Amazon-Elastic-Kubernetes-Service_48.png"
copy_icon "lightsail" "Arch_Compute/48/Arch_Amazon-Lightsail_48.png"

# Storage
copy_icon "s3" "Arch_Storage/48/Arch_Amazon-Simple-Storage-Service_48.png"
copy_icon "efs" "Arch_Storage/48/Arch_Amazon-Elastic-File-System_48.png"

# Database
copy_icon "rds" "Arch_Database/48/Arch_Amazon-RDS_48.png"
copy_icon "dynamodb" "Arch_Database/48/Arch_Amazon-DynamoDB_48.png"
copy_icon "elasticache" "Arch_Database/48/Arch_Amazon-ElastiCache_48.png"

# Networking
copy_icon "vpc" "Arch_Networking-Content-Delivery/48/Arch_Amazon-Virtual-Private-Cloud_48.png"
copy_icon "cloudfront" "Arch_Networking-Content-Delivery/48/Arch_Amazon-CloudFront_48.png"
copy_icon "route53" "Arch_Networking-Content-Delivery/48/Arch_Amazon-Route-53_48.png"
copy_icon "apigateway" "Arch_Networking-Content-Delivery/48/Arch_Amazon-API-Gateway_48.png"

# Management & Monitoring
copy_icon "cloudwatch" "Arch_Management-Governance/48/Arch_Amazon-CloudWatch_48.png"
copy_icon "cloudformation" "Arch_Management-Governance/48/Arch_AWS-CloudFormation_48.png"
copy_icon "systems-manager" "Arch_Management-Governance/48/Arch_AWS-Systems-Manager_48.png"

# Security & Identity
copy_icon "iam" "Arch_Security-Identity-Compliance/48/Arch_AWS-Identity-and-Access-Management_48.png"
copy_icon "secrets-manager" "Arch_Security-Identity-Compliance/48/Arch_AWS-Secrets-Manager_48.png"
copy_icon "kms" "Arch_Security-Identity-Compliance/48/Arch_AWS-Key-Management-Service_48.png"
copy_icon "cognito" "Arch_Security-Identity-Compliance/48/Arch_Amazon-Cognito_48.png"
copy_icon "waf" "Arch_Security-Identity-Compliance/48/Arch_AWS-WAF_48.png"

# Application Integration
copy_icon "sqs" "Arch_App-Integration/48/Arch_Amazon-Simple-Queue-Service_48.png"
copy_icon "sns" "Arch_App-Integration/48/Arch_Amazon-Simple-Notification-Service_48.png"
copy_icon "eventbridge" "Arch_App-Integration/48/Arch_Amazon-EventBridge_48.png"
copy_icon "step-functions" "Arch_App-Integration/48/Arch_AWS-Step-Functions_48.png"

# Developer Tools
copy_icon "codecommit" "Arch_Developer-Tools/48/Arch_AWS-CodeCommit_48.png"
copy_icon "codebuild" "Arch_Developer-Tools/48/Arch_AWS-CodeBuild_48.png"
copy_icon "codepipeline" "Arch_Developer-Tools/48/Arch_AWS-CodePipeline_48.png"

# Analytics
copy_icon "athena" "Arch_Analytics/48/Arch_Amazon-Athena_48.png"
copy_icon "glue" "Arch_Analytics/48/Arch_AWS-Glue_48.png"

# クリーンアップ
rm -rf "$TMP_DIR"

echo ""
echo "Done! Icons are in $ICONS_DIR"
ls "$ICONS_DIR" | wc -l | xargs echo "Total icons:"
