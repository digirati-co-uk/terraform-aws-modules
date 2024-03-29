output "id" {
  description = "URL for the created SQS queue"
  value       = aws_sqs_queue.q.id
}

output "arn" {
  description = "ARN for the created SQS queue"
  value       = aws_sqs_queue.q.arn
}

output "read_policy" {
  description = "Policy that allows reading from the created SQS queue"
  value       = data.aws_iam_policy_document.read_from_queue.json
}

output "write_policy" {
  description = "Policy that allows writing to the created SQS queue"
  value       = data.aws_iam_policy_document.write_to_queue.json
}

output "name" {
  description = "Name of the created SQS queue"
  value       = aws_sqs_queue.q.name
}
