-- plugins/aws/services.lua
-- AWSサービス定義データ

-- グローバルサービス（リージョン不要）
-- has_global_region = true のサービスは console.aws.amazon.com を使用

return {
    -- Compute
    {
        id = "ec2",
        name = "Elastic Compute Cloud",
        short_name = "EC2",
        description = "Virtual servers in the cloud",
        url = "/ec2/home",
    },
    {
        id = "lambda",
        name = "Lambda",
        short_name = "Lambda",
        description = "Run code without thinking about servers",
        url = "/lambda/home",
    },
    {
        id = "ecs",
        name = "Elastic Container Service",
        short_name = "ECS",
        description = "Run containerized applications",
        url = "/ecs/home",
    },
    {
        id = "eks",
        name = "Elastic Kubernetes Service",
        short_name = "EKS",
        description = "Run Kubernetes on AWS",
        url = "/eks/home",
    },
    {
        id = "lightsail",
        name = "Lightsail",
        short_name = "Lightsail",
        description = "Launch and manage virtual private servers",
        url = "/lightsail/home",
    },

    -- Storage
    {
        id = "s3",
        name = "Simple Storage Service",
        short_name = "S3",
        description = "Scalable storage in the cloud",
        url = "/s3/home",
    },
    {
        id = "efs",
        name = "Elastic File System",
        short_name = "EFS",
        description = "Managed file storage for EC2",
        url = "/efs/home",
    },

    -- Database
    {
        id = "rds",
        name = "Relational Database Service",
        short_name = "RDS",
        description = "Managed relational database service",
        url = "/rds/home",
    },
    {
        id = "dynamodb",
        name = "DynamoDB",
        short_name = "DynamoDB",
        description = "Managed NoSQL database",
        url = "/dynamodbv2/home",
    },
    {
        id = "elasticache",
        name = "ElastiCache",
        short_name = "ElastiCache",
        description = "In-memory caching service",
        url = "/elasticache/home",
    },

    -- Networking
    {
        id = "vpc",
        name = "Virtual Private Cloud",
        short_name = "VPC",
        description = "Isolated cloud resources",
        url = "/vpcconsole/home",
    },
    {
        id = "cloudfront",
        name = "CloudFront",
        short_name = "CloudFront",
        description = "Global content delivery network",
        url = "/cloudfront/home",
        has_global_region = true,
    },
    {
        id = "route53",
        name = "Route 53",
        short_name = "Route 53",
        description = "Scalable DNS and domain registration",
        url = "/route53/home",
        has_global_region = true,
    },
    {
        id = "apigateway",
        name = "API Gateway",
        short_name = "API Gateway",
        description = "Build, deploy, and manage APIs",
        url = "/apigateway/home",
    },

    -- Management & Monitoring
    {
        id = "cloudwatch",
        name = "CloudWatch",
        short_name = "CloudWatch",
        description = "Monitor resources and applications",
        url = "/cloudwatch/home",
    },
    {
        id = "cloudformation",
        name = "CloudFormation",
        short_name = "CloudFormation",
        description = "Create and manage resources with templates",
        url = "/cloudformation/home",
    },
    {
        id = "systems-manager",
        name = "Systems Manager",
        short_name = "SSM",
        description = "Manage EC2 and on-premises systems",
        url = "/systems-manager/home",
    },

    -- Security & Identity
    {
        id = "iam",
        name = "Identity and Access Management",
        short_name = "IAM",
        description = "Manage access to AWS resources",
        url = "/iam/home",
        has_global_region = true,
    },
    {
        id = "secrets-manager",
        name = "Secrets Manager",
        short_name = "Secrets Manager",
        description = "Rotate, manage, and retrieve secrets",
        url = "/secretsmanager/home",
    },
    {
        id = "kms",
        name = "Key Management Service",
        short_name = "KMS",
        description = "Create and manage encryption keys",
        url = "/kms/home",
    },
    {
        id = "cognito",
        name = "Cognito",
        short_name = "Cognito",
        description = "Identity management for apps",
        url = "/cognito/home",
    },
    {
        id = "waf",
        name = "Web Application Firewall",
        short_name = "WAF",
        description = "Protect web applications from exploits",
        url = "/wafv2/home",
    },

    -- Application Integration
    {
        id = "sqs",
        name = "Simple Queue Service",
        short_name = "SQS",
        description = "Managed message queuing service",
        url = "/sqs/home",
    },
    {
        id = "sns",
        name = "Simple Notification Service",
        short_name = "SNS",
        description = "Managed pub/sub messaging",
        url = "/sns/home",
    },
    {
        id = "eventbridge",
        name = "EventBridge",
        short_name = "EventBridge",
        description = "Serverless event bus",
        url = "/events/home",
    },
    {
        id = "step-functions",
        name = "Step Functions",
        short_name = "Step Functions",
        description = "Coordinate distributed applications",
        url = "/states/home",
    },

    -- Developer Tools
    {
        id = "codecommit",
        name = "CodeCommit",
        short_name = "CodeCommit",
        description = "Host private Git repositories",
        url = "/codesuite/codecommit/home",
    },
    {
        id = "codebuild",
        name = "CodeBuild",
        short_name = "CodeBuild",
        description = "Build and test code",
        url = "/codesuite/codebuild/home",
    },
    {
        id = "codepipeline",
        name = "CodePipeline",
        short_name = "CodePipeline",
        description = "Automate continuous delivery pipelines",
        url = "/codesuite/codepipeline/home",
    },

    -- Analytics
    {
        id = "athena",
        name = "Athena",
        short_name = "Athena",
        description = "Query data in S3 using SQL",
        url = "/athena/home",
    },
    {
        id = "glue",
        name = "Glue",
        short_name = "Glue",
        description = "Prepare and load data",
        url = "/glue/home",
    },
}
