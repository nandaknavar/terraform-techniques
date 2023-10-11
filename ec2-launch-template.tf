resource "aws_launch_template" "br" {
  name = "br-lt"

  image_id               = data.aws_ssm_parameter.ecs_ami.value
  vpc_security_group_ids = [aws_security_group.main.id]

  tags = {
    "Name" = "br-lt"
    "AMI"  = data.aws_ssm_parameter.ecs_ami.value
  }
}

data "aws_ssm_parameter" "ecs_ami" {
  name = var.auto_scaling_group.ami_name
}