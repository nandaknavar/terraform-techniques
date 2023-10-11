variable "region" {
  description = "aws region name"
  type        = string
}

variable "deploy_env" {
  description = "Deploy environment (ex. dev, tst, prd)"
  type        = string
}

variable "lifecycle_rules" {
  description = "Rules for archiving objects to different storage classes"
  type = object({
    status                 = string
    minimum_object_size    = number
    noncurrent_expire_days = number
    expiration_days        = number
    transition = list(object({
      days          = number
      storage_class = string
    }))
  })
}

variable "lifecycle_prefix_rules" {
  description = "Rules for moving objects in prefixes to different storage classes"
  type        = map(any)
}

variable "efs_ia_transition" {
  description = "Number of days to transition to different storage class"
  type        = string
}

variable "auto_scaling_group" {
  description = "Auto scaling group parameters"
  type = object({
    max_size          = number
    min_size          = number
    vcpu_min          = number
    vcpu_max          = number
    memory_min        = number
    memory_max        = number
    od_base_capacity  = number
    od_percent_on_top = number
    spot_strategy     = string
    ami_name          = string
    instance_lifetime = number
  })
}