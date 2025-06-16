output "LambdaInvokeArn" {
  value = aws_lambda_function.put_lambda.invoke_arn
}
output "functionName" {
  value = aws_lambda_function.put_lambda.function_name
}