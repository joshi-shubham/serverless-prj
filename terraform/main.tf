

resource "aws_dynamodb_table" "remainder-table"{
    name = "remainders"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "Id"
    attribute {
        name = "Id"
        type = "N"
    }
    
    ttl {
      attribute_name = "TimeToLive"
      enabled = true
    }
    stream_enabled = true
    stream_view_type = "NEW_AND_OLD_IMAGES"
}

module "putReminderLambda"{
  source = "./putReminderLambda"
  lambda_arn = aws_iam_role.lambda_role.arn
}

module "sendMessageLambda" {
  source = "./sendMessageLambda"
  lambda_arn = aws_iam_role.lambda_role.arn
  dynamodb_stream_arn = aws_dynamodb_table.remainder-table.stream_arn
}

