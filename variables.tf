
# VPC configuration
variable "vpc_config" {
  description = "VPC configuration settings. The attribute 'cidr_block' is required."
  type = object({
    cidr_block = string
    vpc_name   = optional(string)
  })
}

# VSwitch configurations for different components
variable "vswitch_configs" {
  description = "Map of VSwitch configurations for different components (ecs, rds, redis)"
  type = map(object({
    cidr_block   = string
    zone_id      = string
    vswitch_name = optional(string)
  }))
}

# Security group configuration
variable "security_group_config" {
  description = "Security group configuration settings"
  type = object({
    security_group_name = optional(string, null)
    description         = optional(string, "Security group for end-to-end tracing solution")
  })
  default = {
    description = "Security group for end-to-end tracing solution"
  }
}

# Security group rules
variable "security_group_rules" {
  description = "Map of security group rules configuration"
  type = map(object({
    type        = string
    ip_protocol = string
    nic_type    = string
    policy      = string
    port_range  = string
    priority    = number
    cidr_ip     = string
  }))
  default = {
    "allow_web" = {
      type        = "ingress"
      ip_protocol = "tcp"
      nic_type    = "intranet"
      policy      = "accept"
      port_range  = "80/80"
      priority    = 1
      cidr_ip     = "0.0.0.0/0"
    }
  }
}


# ECS instance configuration
variable "ecs_config" {
  description = "ECS instance configuration. The attributes 'image_id', 'instance_type', 'system_disk_category', 'password' are required."
  type = object({
    image_id                   = string
    instance_type              = string
    system_disk_category       = string
    password                   = string
    instance_name              = optional(string)
    internet_max_bandwidth_out = optional(number, 5)
  })
}

# RDS configuration
variable "rds_config" {
  description = "RDS database instance configuration. The attributes 'instance_type', 'zone_id', 'instance_storage', 'category', 'db_instance_storage_type', 'engine', 'engine_version' are required."
  type = object({
    instance_type            = string
    zone_id                  = string
    instance_storage         = number
    category                 = string
    db_instance_storage_type = string
    engine                   = string
    engine_version           = string
    security_ips             = list(string)
  })
  default = {
    instance_type            = null
    zone_id                  = null
    instance_storage         = 50
    category                 = "Basic"
    db_instance_storage_type = "cloud_essd"
    engine                   = "MySQL"
    engine_version           = "8.0"
    security_ips             = ["192.168.0.0/16"]
  }
}

# RDS account configuration
variable "rds_account_config" {
  description = "RDS account configuration. The attributes 'account_name', 'account_password' are required."
  type = object({
    account_type     = string
    account_name     = string
    account_password = string
    privilege        = string
  })
  default = {
    account_type     = "Normal"
    account_name     = null
    account_password = null
    privilege        = "ReadWrite"
  }
}

# RDS database configuration
variable "rds_database_config" {
  description = "RDS database configuration"
  type = object({
    character_set = string
    name          = string
  })
  default = {
    character_set = "utf8"
    name          = "flashsale"
  }
}

# Redis configuration
variable "redis_config" {
  description = "Redis instance configuration. The attributes 'engine_version', 'zone_id', 'instance_class', 'password' are required."
  type = object({
    engine_version   = string
    zone_id          = string
    instance_class   = string
    password         = string
    shard_count      = optional(number, 1)
    db_instance_name = optional(string)
    security_ips     = optional(list(string), ["192.168.0.0/16"])
  })
}

# RocketMQ instance configuration
variable "rocketmq_config" {
  description = "RocketMQ instance configuration. The attributes 'msg_process_spec', 'message_retention_time', 'sub_series_code', 'series_code', 'payment_type', 'service_code' are required."
  type = object({
    msg_process_spec       = string
    message_retention_time = string
    sub_series_code        = string
    series_code            = string
    payment_type           = string
    service_code           = string
    instance_name          = optional(string)
    internet_spec          = optional(string, "disable")
    flow_out_type          = optional(string, "uninvolved")
    acl_types              = optional(list(string), ["default", "apache_acl"])
    default_vpc_auth_free  = optional(bool, false)
  })
}

# RocketMQ account configuration
variable "rocketmq_account_config" {
  description = "RocketMQ account configuration. The attributes 'username', 'password' are required."
  type = object({
    account_status = string
    username       = string
    password       = string
  })
  default = {
    account_status = "ENABLE"
    username       = null
    password       = null
  }
}

# RocketMQ topics configuration
variable "rocketmq_topics" {
  description = "Map of RocketMQ topics configuration"
  type = map(object({
    remark       = string
    message_type = string
  }))
  default = {
    "order-fail-after-pre-deducted-inventory" = {
      remark       = "Order creation failed after pre-deducted inventory success"
      message_type = "NORMAL"
    }
    "order-fail-after-deducted-inventory" = {
      remark       = "Order creation failed after inventory deduction success"
      message_type = "NORMAL"
    }
    "order-success" = {
      remark       = "Order creation success"
      message_type = "TRANSACTION"
    }
  }
}

# RocketMQ consumer group configuration
variable "rocketmq_consumer_group_config" {
  description = "RocketMQ consumer group configuration"
  type = object({
    consumer_group_id   = string
    delivery_order_type = string
    retry_policy        = string
    max_retry_times     = number
  })
  default = {
    consumer_group_id   = "flashsale-service-consumer-group"
    delivery_order_type = "Concurrently"
    retry_policy        = "DefaultRetryPolicy"
    max_retry_times     = 5
  }
}

# RocketMQ ACL configuration
variable "rocketmq_acl_config" {
  description = "RocketMQ ACL configuration"
  type = object({
    topic_actions = list(string)
    group_actions = list(string)
    decision      = string
    ip_whitelists = list(string)
  })
  default = {
    topic_actions = ["Pub", "Sub"]
    group_actions = ["Sub"]
    decision      = "Allow"
    ip_whitelists = ["192.168.0.0/16"]
  }
}

# MSE cluster configuration
variable "mse_config" {
  description = "MSE cluster configuration. The attributes 'mse_version', 'instance_count', 'cluster_version', 'cluster_type', 'cluster_specification', 'net_type', 'pub_network_flow' are required."
  type = object({
    mse_version           = string
    instance_count        = number
    cluster_version       = string
    cluster_type          = string
    cluster_specification = string
    net_type              = string
    pub_network_flow      = number
    cluster_alias_name    = optional(string)
    nacos_endpoint        = string
  })
}

# Custom script variable for override
variable "custom_deployment_script" {
  description = "Optional custom deployment script to override the default script"
  type        = string
  default     = null
}

# ECS command configuration
variable "ecs_command_config" {
  description = "ECS cloud assistant command configuration"
  type = object({
    name        = optional(string)
    working_dir = string
    type        = string
    timeout     = number
  })
  default = {
    working_dir = "/root"
    type        = "RunShellScript"
    timeout     = 3600
  }
}

# ECS invocation configuration
variable "ecs_invocation_config" {
  description = "ECS command invocation configuration"
  type = object({
    timeout = string
  })
  default = {
    timeout = "15m"
  }
}

# License configuration
variable "license_config" {
  description = "License keys configuration for MSE and ARMS. Both 'mse_license_key' and 'arms_license_key' are required."
  type = object({
    mse_license_key  = string
    arms_license_key = string
  })
}