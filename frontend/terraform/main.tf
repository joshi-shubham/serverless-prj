resource "aws_s3_bucket" "reminderapp-frontend-pipeline" {
  bucket = "reminderapp-frontend-pipeline"
}

# resource "aws_s3_bucket_acl" "pipeline-bucket-acl" {
#   bucket = aws_s3_bucket.reminderapp-frontend-pipeline.id
#   acl    = "private"
# }

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}
resource "aws_iam_role" "codebuild_iam_role" {
  name = "codebuild-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "codebuild_role_policy" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DescribeDhcpOptions",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface",
      "ec2:DescribeSubnets",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeVpcs",
    ]

    resources = ["*"]
  }
    statement {
    effect  = "Allow"
    actions = ["s3:*"]
    resources = [
      aws_s3_bucket.reminderapp-frontend-pipeline.arn,
      "${aws_s3_bucket.reminderapp-frontend-pipeline.arn}/*",
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "codeconnections:*"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "example" {
  role   = aws_iam_role.codebuild_iam_role.name
  policy = data.aws_iam_policy_document.codebuild_role_policy.json
}


resource "aws_codebuild_project" "frontend_build" {
  name = "frontend-build"
  build_timeout = 5
  service_role = aws_iam_role.codebuild_iam_role.arn
  artifacts {
    type = "NO_ARTIFACTS"
  }
  cache {
    type = "S3"
    location = aws_s3_bucket.reminderapp-frontend-pipeline.bucket
  }
  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }
  logs_config {
    cloudwatch_logs {
      group_name  = "log-group"
      stream_name = "log-stream"
    }

    s3_logs {
      status   = "ENABLED"
      location = "${aws_s3_bucket.reminderapp-frontend-pipeline.id}/build-log"
    }
  }

  source {
    type = "GITHUB"
    location = "https://github.com/joshi-shubham/serverless-prj"
    auth {
      type = "CODECONNECTIONS"
      resource = "arn:aws:codeconnections:us-east-1:211125522070:connection/814a901c-e45d-4860-8bab-4d0ca364dbbc"
    }
    buildspec = "frontend/reminder-app/buildspec.yml"

  }
  
  source_version = "main"
}