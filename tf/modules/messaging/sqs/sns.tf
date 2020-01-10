resource "aws_sns_topic_subscription" "sns_topic" {
  protocol  = "sqs"
  topic_arn = format("arn:aws:sns:%s:%s:%s", var.region, var.account_id, var.topic_name)
  endpoint  = aws_sqs_queue.q.arn
}
