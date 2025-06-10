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

resource "aws_api_gateway_method" "api_method_options" {
  rest_api_id = aws_api_gateway_rest_api.reminder_api.id
  resource_id = aws_api_gateway_resource.reminder_api_resource.id
  http_method = "OPTIONS"
  authorization = "NONE"
  depends_on = [ aws_api_gateway_resource.reminder_api_resource, aws_api_gateway_rest_api.reminder_api ]
}

resource "aws_api_gateway_integration" "api_put_reminder_integration_options" {
  rest_api_id = aws_api_gateway_rest_api.reminder_api.id
  resource_id = aws_api_gateway_resource.reminder_api_resource.id
  http_method = aws_api_gateway_method.api_method_options.http_method
  type = "MOCK"
    request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_method_response" "response_options_200" {
  rest_api_id = aws_api_gateway_rest_api.reminder_api.id
  resource_id = aws_api_gateway_resource.reminder_api_resource.id
  http_method = aws_api_gateway_method.api_method_options.http_method
  status_code = "200"
  response_models = {
        "application/json" = "Empty"
    }
    response_parameters = {
        "method.response.header.Access-Control-Allow-Headers" = true,
        "method.response.header.Access-Control-Allow-Methods" = true,
        "method.response.header.Access-Control-Allow-Origin" = true
    }
  depends_on = [ aws_api_gateway_rest_api.reminder_api, aws_api_gateway_resource.reminder_api_resource, aws_api_gateway_method.api_method_options ]
}

resource "aws_api_gateway_integration_response" "integrate_response_options_200" {
  rest_api_id = aws_api_gateway_rest_api.reminder_api.id
  resource_id = aws_api_gateway_resource.reminder_api_resource.id
  http_method = aws_api_gateway_method.api_method_options.http_method
  status_code = aws_api_gateway_method_response.response_options_200.status_code
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'",
    "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS,POST'"
  }
  depends_on = [
    aws_api_gateway_integration.api_put_reminder_integration_options
  ]
}

resource "aws_api_gateway_integration" "api_put_reminder_integration" {
  rest_api_id = aws_api_gateway_rest_api.reminder_api.id
  resource_id = aws_api_gateway_resource.reminder_api_resource.id
  http_method = aws_api_gateway_method.api_method.http_method
  integration_http_method = "POST"
  type = "AWS"
  uri = module.putReminderLambda.LambdaInvokeArn
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
  function_name = module.putReminderLambda.functionName
  principal     = "apigateway.amazonaws.com"


  source_arn = "${aws_api_gateway_rest_api.reminder_api.execution_arn}/*"
  depends_on = [ module.putReminderLambda, aws_api_gateway_rest_api.reminder_api ]
}

resource "aws_api_gateway_method_response" "response_200" {
  rest_api_id = aws_api_gateway_rest_api.reminder_api.id
  resource_id = aws_api_gateway_resource.reminder_api_resource.id
  http_method = aws_api_gateway_method.api_method.http_method
  status_code = "200"
 
    response_parameters = {
        "method.response.header.Access-Control-Allow-Origin" = true
    }
  depends_on = [ aws_api_gateway_rest_api.reminder_api, aws_api_gateway_resource.reminder_api_resource, aws_api_gateway_method.api_method ]
}

resource "aws_api_gateway_integration_response" "integrate_response_200" {
  rest_api_id = aws_api_gateway_rest_api.reminder_api.id
  resource_id = aws_api_gateway_resource.reminder_api_resource.id
  http_method = aws_api_gateway_method.api_method.http_method
  status_code = aws_api_gateway_method_response.response_200.status_code
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }
  depends_on = [
    aws_api_gateway_integration.api_put_reminder_integration
  ]
}

