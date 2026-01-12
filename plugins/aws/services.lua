-- plugins/aws/services.lua
-- AWSサービス定義データ

-- グローバルサービス（リージョン不要）
-- has_global_region = true のサービスは console.aws.amazon.com を使用
-- icon はファイル名のみ（plugins/aws/icons/ 配下に配置）

return {
    -- Compute
    {
        id = "ec2",
        name = "Elastic Compute Cloud",
        short_name = "EC2",
        description = "Virtual servers in the cloud",
        url = "/ec2/home",
        icon = "ec2.png",
    },
    {
        id = "lambda",
        name = "Lambda",
        short_name = "Lambda",
        description = "Run code without thinking about servers",
        url = "/lambda/home",
        icon = "lambda.png",
    },
    {
        id = "ecs",
        name = "Elastic Container Service",
        short_name = "ECS",
        description = "Run containerized applications",
        url = "/ecs/home",
        icon = "ecs.png",
    },
    {
        id = "eks",
        name = "Elastic Kubernetes Service",
        short_name = "EKS",
        description = "Run Kubernetes on AWS",
        url = "/eks/home",
        icon = "eks.png",
    },
    {
        id = "lightsail",
        name = "Lightsail",
        short_name = "Lightsail",
        description = "Launch and manage virtual private servers",
        url = "/lightsail/home",
        icon = "lightsail.png",
    },

    -- Storage
    {
        id = "s3",
        name = "Simple Storage Service",
        short_name = "S3",
        description = "Scalable storage in the cloud",
        url = "/s3/home",
        icon = "s3.png",
    },
    {
        id = "efs",
        name = "Elastic File System",
        short_name = "EFS",
        description = "Managed file storage for EC2",
        url = "/efs/home",
        icon = "efs.png",
    },

    -- Database
    {
        id = "rds",
        name = "Relational Database Service",
        short_name = "RDS",
        description = "Managed relational database service",
        url = "/rds/home",
        icon = "rds.png",
    },
    {
        id = "dynamodb",
        name = "DynamoDB",
        short_name = "DynamoDB",
        description = "Managed NoSQL database",
        url = "/dynamodbv2/home",
        icon = "dynamodb.png",
    },
    {
        id = "elasticache",
        name = "ElastiCache",
        short_name = "ElastiCache",
        description = "In-memory caching service",
        url = "/elasticache/home",
        icon = "elasticache.png",
    },

    -- Networking
    {
        id = "vpc",
        name = "Virtual Private Cloud",
        short_name = "VPC",
        description = "Isolated cloud resources",
        url = "/vpcconsole/home",
        icon = "vpc.png",
    },
    {
        id = "cloudfront",
        name = "CloudFront",
        short_name = "CloudFront",
        description = "Global content delivery network",
        url = "/cloudfront/home",
        has_global_region = true,
        icon = "cloudfront.png",
    },
    {
        id = "route53",
        name = "Route 53",
        short_name = "Route 53",
        description = "Scalable DNS and domain registration",
        url = "/route53/home",
        has_global_region = true,
        icon = "route53.png",
    },
    {
        id = "apigateway",
        name = "API Gateway",
        short_name = "API Gateway",
        description = "Build, deploy, and manage APIs",
        url = "/apigateway/home",
        icon = "apigateway.png",
    },

    -- Management & Monitoring
    {
        id = "cloudwatch",
        name = "CloudWatch",
        short_name = "CloudWatch",
        description = "Monitor resources and applications",
        url = "/cloudwatch/home",
        icon = "cloudwatch.png",
    },
    {
        id = "cloudformation",
        name = "CloudFormation",
        short_name = "CloudFormation",
        description = "Create and manage resources with templates",
        url = "/cloudformation/home",
        icon = "cloudformation.png",
    },
    {
        id = "systems-manager",
        name = "Systems Manager",
        short_name = "SSM",
        description = "Manage EC2 and on-premises systems",
        url = "/systems-manager/home",
        icon = "systems-manager.png",
    },

    -- Security & Identity
    {
        id = "iam",
        name = "Identity and Access Management",
        short_name = "IAM",
        description = "Manage access to AWS resources",
        url = "/iam/home",
        has_global_region = true,
        icon = "iam.png",
    },
    {
        id = "secrets-manager",
        name = "Secrets Manager",
        short_name = "Secrets Manager",
        description = "Rotate, manage, and retrieve secrets",
        url = "/secretsmanager/home",
        icon = "secrets-manager.png",
    },
    {
        id = "kms",
        name = "Key Management Service",
        short_name = "KMS",
        description = "Create and manage encryption keys",
        url = "/kms/home",
        icon = "kms.png",
    },
    {
        id = "cognito",
        name = "Cognito",
        short_name = "Cognito",
        description = "Identity management for apps",
        url = "/cognito/home",
        icon = "cognito.png",
    },
    {
        id = "waf",
        name = "Web Application Firewall",
        short_name = "WAF",
        description = "Protect web applications from exploits",
        url = "/wafv2/home",
        icon = "waf.png",
    },

    -- Application Integration
    {
        id = "sqs",
        name = "Simple Queue Service",
        short_name = "SQS",
        description = "Managed message queuing service",
        url = "/sqs/home",
        icon = "sqs.png",
    },
    {
        id = "sns",
        name = "Simple Notification Service",
        short_name = "SNS",
        description = "Managed pub/sub messaging",
        url = "/sns/home",
        icon = "sns.png",
    },
    {
        id = "eventbridge",
        name = "EventBridge",
        short_name = "EventBridge",
        description = "Serverless event bus",
        url = "/events/home",
        icon = "eventbridge.png",
    },
    {
        id = "step-functions",
        name = "Step Functions",
        short_name = "Step Functions",
        description = "Coordinate distributed applications",
        url = "/states/home",
        icon = "step-functions.png",
    },

    -- Developer Tools
    {
        id = "codecommit",
        name = "CodeCommit",
        short_name = "CodeCommit",
        description = "Host private Git repositories",
        url = "/codesuite/codecommit/home",
        icon = "codecommit.png",
    },
    {
        id = "codebuild",
        name = "CodeBuild",
        short_name = "CodeBuild",
        description = "Build and test code",
        url = "/codesuite/codebuild/home",
        icon = "codebuild.png",
    },
    {
        id = "codepipeline",
        name = "CodePipeline",
        short_name = "CodePipeline",
        description = "Automate continuous delivery pipelines",
        url = "/codesuite/codepipeline/home",
        icon = "codepipeline.png",
    },

    -- Analytics
    {
        id = "athena",
        name = "Athena",
        short_name = "Athena",
        description = "Query data in S3 using SQL",
        url = "/athena/home",
        icon = "athena.png",
    },
    {
        id = "glue",
        name = "Glue",
        short_name = "Glue",
        description = "Prepare and load data",
        url = "/glue/home",
        icon = "glue.png",
    },
}
