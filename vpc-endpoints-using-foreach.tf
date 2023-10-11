resource "aws_vpc_endpoint" "main" {
  for_each = toset(
    ["airflow.api", "airflow.env", "airflow.ops", "batch", "ecr.api", "ecr.dkr", "kms",
    "logs", "monitoring", "secretsmanager", "ssm", "ssmmessages", "sqs"]
  )

  vpc_id            = data.aws_vpc.main.id
  service_name      = "com.amazonaws.${var.region}.${each.key}"
  vpc_endpoint_type = "Interface"
  subnet_ids        = tolist(data.aws_subnets.private.ids)

  security_group_ids  = [aws_security_group.main.id]
  private_dns_enabled = true

  tags = {
    "Name" = "vpce-${replace(each.key, ".", "-")}-ep"
  }
}