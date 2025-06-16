data "archive_file" "put_lambda" {
  type        = "zip"
  source_file = "putReminderLambda/PutItem.mjs"
  output_path = "lambda_function_payload.zip"
}
variable "lambda_arn" {
  
}

resource "aws_lambda_function" "put_lambda" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = "lambda_function_payload.zip"
  function_name = "put_db"
  role          = var.lambda_arn
  handler       = "PutItem.handler"

  source_code_hash = data.archive_file.put_lambda.output_base64sha256

  runtime = "nodejs22.x"

  
}

resource "aws_cloudwatch_log_group" "put_lambda_log" {
  name              = "/aws/lambda/put_db"
  retention_in_days = 14
}