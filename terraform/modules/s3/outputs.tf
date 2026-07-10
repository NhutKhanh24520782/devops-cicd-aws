output "terraform_state_bucket" {

  value = aws_s3_bucket.terraform_state.bucket

}

output "terraform_state_bucket_arn" {

  value = aws_s3_bucket.terraform_state.arn

}