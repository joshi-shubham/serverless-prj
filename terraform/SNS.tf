# resource "aws_sns_topic" "send_email_sns" {
#   name = "send_reminder"
# }
# resource "aws_sns_topic_subscription" "send_email_sns_subscription" {
#   topic_arn = aws_sns_topic.send_email_sns
#   protocol  = "email"
#   endpoint  = "shubjoshi
# }