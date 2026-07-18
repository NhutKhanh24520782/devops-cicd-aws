# S3 Gateway Endpoint
resource "aws_vpc_endpoint" "s3" {

  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = var.private_route_table_ids

  tags = {
    Name        = "${var.project_name}-s3-endpoint"
    Project     = var.project_name
    Environment = var.environment
    Terraform   = "true"
  }
}


# ECR API Endpoint
resource "aws_vpc_endpoint" "ecr_api" {

  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.ecr.api"
  vpc_endpoint_type = "Interface"

  subnet_ids         = var.intra_subnets
  security_group_ids = [var.endpoint_security_group_id]

  private_dns_enabled = true

  tags = {
    Name = "${var.project_name}-ecr-api-endpoint"
  }
}


# ECR Docker Endpoint
resource "aws_vpc_endpoint" "ecr_dkr" {

  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.ecr.dkr"
  vpc_endpoint_type = "Interface"

  subnet_ids         = var.intra_subnets
  security_group_ids = [var.endpoint_security_group_id]

  private_dns_enabled = true

  tags = {
    Name = "${var.project_name}-ecr-dkr-endpoint"
  }
}


# CloudWatch Logs Endpoint
resource "aws_vpc_endpoint" "logs" {

  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.logs"
  vpc_endpoint_type = "Interface"

  subnet_ids         = var.intra_subnets
  security_group_ids = [var.endpoint_security_group_id]

  private_dns_enabled = true

  tags = {
    Name = "${var.project_name}-logs-endpoint"
  }
}
