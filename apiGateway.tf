resource "aws_api_gateway_rest_api" "reminder_api" {
  name = "ReminderApi"
}
resource "aws_api_gateway_resource" "reminder_api_resource" {
    rest_api_id = aws_api_gateway_rest_api.reminder_api.id
    parent_id = aws_api_gateway_rest_api.reminder_api.root_resource_id
    path_part = "putReminder"
    depends_on = [ aws_api_gateway_rest_api.reminder_api ]
}

resource "aws_api_gateway_method" "api_method" {
  rest_api_id = aws_api_gateway_rest_api.reminder_api.id
  resource_id = aws_api_gateway_resource.reminder_api_resource.id
  http_method = "POST"
  authorization = "NONE"
  depends_on = [ aws_api_gateway_resource.reminder_api_resource, aws_api_gateway_rest_api.reminder_api ]
}

resource "aws_api_gateway_integration" "api_put_reminder_integration" {
  rest_api_id = aws_api_gateway_rest_api.reminder_api.id
  resource_id = aws_api_gateway_resource.reminder_api_resource.id
  http_method = aws_api_gateway_method.api_method.http_method
  integration_http_method = "POST"
  type = "AWS"
  uri = aws_lambda_function.put_lambda.invoke_arn
  depends_on = [ aws_api_gateway_rest_api.reminder_api, aws_api_gateway_resource.reminder_api_resource ]
}

resource "aws_api_gateway_deployment" "api_dev_deploy" {
  rest_api_id = aws_api_gateway_rest_api.reminder_api.id
  depends_on = [ aws_api_gateway_rest_api.reminder_api, aws_api_gateway_integration.api_put_reminder_integration, aws_api_gateway_method_response.response_200 ]
}
resource "aws_api_gateway_stage" "api_dev_stage" {
  rest_api_id = aws_api_gateway_rest_api.reminder_api.id
  stage_name = "dev"
  deployment_id = aws_api_gateway_deployment.api_dev_deploy.id
  depends_on = [ aws_api_gateway_rest_api.reminder_api, aws_api_gateway_deployment.api_dev_deploy ]
}

resource "aws_lambda_permission" "put_lambda_permission" {
  statement_id  = "AllowMyDemoAPIInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.put_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  # The /* part allows invocation from any stage, method and resource path
  # within API Gateway.
  source_arn = "${aws_api_gateway_rest_api.reminder_api.execution_arn}/*"
  depends_on = [ aws_lambda_function.put_lambda, aws_api_gateway_rest_api.reminder_api ]
}

resource "aws_api_gateway_method_response" "response_200" {
  rest_api_id = aws_api_gateway_rest_api.reminder_api.id
  resource_id = aws_api_gateway_resource.reminder_api_resource.id
  http_method = aws_api_gateway_method.api_method.http_method
  status_code = "200"
  depends_on = [ aws_api_gateway_rest_api.reminder_api, aws_api_gateway_resource.reminder_api_resource, aws_api_gateway_method.api_method ]
}

resource "aws_api_gateway_integration_response" "integrate_response_200" {
  rest_api_id = aws_api_gateway_rest_api.reminder_api.id
  resource_id = aws_api_gateway_resource.reminder_api_resource.id
  http_method = aws_api_gateway_method.api_method.http_method
  status_code = aws_api_gateway_method_response.response_200.status_code
}