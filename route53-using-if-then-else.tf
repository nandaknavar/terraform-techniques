resource "aws_route53_record" "ip_route" {
  zone_id = data.aws_route53_zone.private.zone_id
  name    = "sample.${data.aws_route53_zone.private.name}"
  type    = "A"
  records = var.deploy_env == "prod" ? ["10.1.0.5"] : ["10.2.0.5"]
}

data "aws_route53_zone" "private" {
  name         = "${var.deploy_env == "prod" ? "abc" : "abc-${var.deploy_env}"}.internal"
  private_zone = true
}