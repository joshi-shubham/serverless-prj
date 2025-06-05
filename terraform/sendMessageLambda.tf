data "archive_file" "send_message_lambda" {
  type        = "zip"
  source_file = "sendMessage.mjs"
  output_path = "sendMessage_function_payload.zip"
}

resource "aws_lambda_function" "send_message_lambda" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = "sendMessage_function_payload.zip"
  function_name = "sendMessage"
  role          = aws_iam_role.lambda_role.arn
  handler       = "sendMessage.handler"

  source_code_hash = data.archive_file.send_message_lambda.output_base64sha256

  runtime = "nodejs22.x"

  
}

resource "aws_cloudwatch_log_group" "send_message_lambda_log" {
  name              = "/aws/lambda/send_message"
  retention_in_days = 14
}

resource "aws_lambda_event_source_mapping" "dynamo_trigger_lambda" {
  event_source_arn  = aws_dynamodb_table.remainder-table.stream_arn
  function_name     = aws_lambda_function.send_message_lambda.arn
  starting_position = "LATEST"

  tags = {
    Name = "dynamodb"
  }
}