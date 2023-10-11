# terraform-techniques

This repo contains useful Terraform syntax to provision cloud resources using IaC. Here a few AWS resources are defined to illustrate some techniques and best practices.

    terraform init
    terraform plan -var-file=tfvars.json

## Lookup using single filter
Use data source to lookup VPC ID using name tag.  
[vpc-lookup-by-filter.tf](vpc-lookup-by-filter.tf)

## Lookup using multiple filters
Use data source to lookup subnet IDs using VPC ID and name tag.  
[subnets-lookup-multiple-filters.tf](subnets-lookup-multiple-filters.tf)

## Manage several similar resources without writing separate blocks for each one (DRY principle)
Define multiple VPC endpoints with for_each meta-argument passing a set of strings.  
[vpc-endpoints-using-foreach.tf](vpc-endpoints-using-foreach.tf)

Enforce multiple security group inbound rules with for_each passing a map of key value pairs, in this example CIDR ranges are passed to open HTTPS port 443 to certain IPs.    
[security-group-inbound-rules-using-foreach.tf](security-group-inbound-rules-using-foreach.tf)

## Separate configuration and code to create clean code using dynamic rules
Use dynamic block to iterate over S3 lifecycle rules to transition objects to different S3 storage classes. In tfvars.json, the transition list in the lifecycle_rules variable can accommodate any number of transition rules. No need to change code for any changes to S3 transition rules and can be managed through tfvars.json. The rules also help to save costs using low cost storage solutions.  
[s3-lifecycle-with-multiple-transitions.tf](s3-lifecycle-with-multiple-transitions.tf)

Again use dynamic block to iterate over S3 lifecycle prefix rules to transition objects in different prefixes to different S3 storage classes. In tfvars.json, lifecycle_prefix_rules map can be customized to define transition rules for different S3 prefixes.  
[s3-lifecycle-for-multiple-prefix.tf](s3-lifecycle-for-multiple-prefix.tf)

## Check using conditional expressions
Value of boolean expression can be used to select one of two values. In this example deploy_env variable is checked for prod value and depending on the result, route53 hosted zone name string is formed for lookup.  
[route53-using-if-then-else.tf](route53-using-if-then-else.tf)

## Upgrade to recent provider version to make use of new features
Specify instance requirements in auto scaling group using vcpu/memory instead of specific instance type. This specification is part of a new provider version and earlier versions supported just the instance type. Benefits of specifying vcpu/memory instead of instance type is that AWS will select an appropriate newer generation instance type based on the resource requirements and will have better price performance.  
Make use of instance distribution to create a balance of on-demand and spot instances. Here for a total auto scaling group size of 8 nodes, 2 nodes will be on-demand and the rest will be spot. Spot instances provide upto 70% cost savings but with a caveat of instance getting terminated with a 2 minute warning and can be used for fault-tolerant workloads.  
[auto-scaling-group.tf](auto-scaling-group.tf)

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.57.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.57.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_group.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_efs_access_point.share](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_access_point) | resource |
| [aws_efs_file_system.share](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_file_system) | resource |
| [aws_efs_file_system_policy.deny_unsecure](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_file_system_policy) | resource |
| [aws_efs_mount_target.share](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_mount_target) | resource |
| [aws_launch_template.br](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_route53_record.ip_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_s3_bucket.archive](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.data](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_lifecycle_configuration.policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_security_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_vpc_endpoint.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_security_group_ingress_rule.https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_iam_policy_document.deny_unsecure](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_route53_zone.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |
| [aws_ssm_parameter.ecs_ami](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_subnets.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_auto_scaling_group"></a> [auto\_scaling\_group](#input\_auto\_scaling\_group) | Auto scaling group parameters | <pre>object({<br>    max_size          = number<br>    min_size          = number<br>    vcpu_min          = number<br>    vcpu_max          = number<br>    memory_min        = number<br>    memory_max        = number<br>    od_base_capacity  = number<br>    od_percent_on_top = number<br>    spot_strategy     = string<br>    ami_name          = string<br>    instance_lifetime = number<br>  })</pre> | n/a | yes |
| <a name="input_deploy_env"></a> [deploy\_env](#input\_deploy\_env) | Deploy environment (ex. dev, tst, prd) | `string` | n/a | yes |
| <a name="input_efs_ia_transition"></a> [efs\_ia\_transition](#input\_efs\_ia\_transition) | Number of days to transition to different storage class | `string` | n/a | yes |
| <a name="input_lifecycle_prefix_rules"></a> [lifecycle\_prefix\_rules](#input\_lifecycle\_prefix\_rules) | Rules for moving objects in prefixes to different storage classes | `map(any)` | n/a | yes |
| <a name="input_lifecycle_rules"></a> [lifecycle\_rules](#input\_lifecycle\_rules) | Rules for archiving objects to different storage classes | <pre>object({<br>    status                 = string<br>    minimum_object_size    = number<br>    noncurrent_expire_days = number<br>    expiration_days        = number<br>    transition = list(object({<br>      days          = number<br>      storage_class = string<br>    }))<br>  })</pre> | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | aws region name | `string` | n/a | yes |

## Outputs

No outputs.
