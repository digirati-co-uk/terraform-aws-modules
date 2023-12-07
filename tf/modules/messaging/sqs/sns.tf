resource "aws_sns_topic_subscription" "sns_topic" {
  protocol             = "sqs"
  topic_arn            = local.topic_arn
  endpoint             = aws_sqs_queue.q.arn
  raw_message_delivery = var.raw_message_delivery
  filter_policy        = var.filter_policy
  filter_policy_scope  = var.filter_policy_scope
}
