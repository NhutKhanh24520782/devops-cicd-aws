output "state_bucket_name" {
  description = "Name of the S3 bucket — copy this value into versions.tf backend block"
  value       = aws_s3_bucket.tf_state.bucket
}

output "state_bucket_arn" {
  description = "ARN of the S3 state bucket"
  value       = aws_s3_bucket.tf_state.arn
}

output "lock_table_name" {
  description = "Name of the DynamoDB lock table — copy this value into versions.tf backend block"
  value       = aws_dynamodb_table.tf_lock.name
}
