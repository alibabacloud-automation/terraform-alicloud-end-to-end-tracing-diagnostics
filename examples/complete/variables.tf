# Basic configuration
variable "region" {
  description = "The Alibaba Cloud region to deploy resources"
  type        = string
  default     = "cn-hangzhou"
}

# VPC configuration
variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "192.168.0.0/16"
}

variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
  default     = "end-to-end-tracing-vpc"
}

# VSwitch configurations
variable "ecs_vswitch_cidr_block" {
  description = "The CIDR block for the ECS VSwitch"
  type        = string
  default     = "192.168.1.0/24"
}

variable "ecs_vswitch_name" {
  description = "The name of the ECS VSwitch"
  type        = string
  default     = "end-to-end-tracing-ecs-vsw"
}

variable "rds_vswitch_cidr_block" {
  description = "The CIDR block for the RDS VSwitch"
  type        = string
  default     = "192.168.2.0/24"
}

variable "rds_vswitch_name" {
  description = "The name of the RDS VSwitch"
  type        = string
  default     = "end-to-end-tracing-rds-vsw"
}

variable "redis_vswitch_cidr_block" {
  description = "The CIDR block for the Redis VSwitch"
  type        = string
  default     = "192.168.3.0/24"
}

variable "redis_vswitch_name" {
  description = "The name of the Redis VSwitch"
  type        = string
  default     = "end-to-end-tracing-redis-vsw"
}

# Security group configuration
variable "security_group_name" {
  description = "The name of the security group"
  type        = string
  default     = "end-to-end-tracing-sg"
}

variable "security_group_description" {
  description = "The description of the security group"
  type        = string
  default     = "Security group for end-to-end tracing solution"
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
      cidr_ip     = "192.168.0.0/16"
    },
    "allow_ssh" = {
      type        = "ingress"
      ip_protocol = "tcp"
      nic_type    = "intranet"
      policy      = "accept"
      port_range  = "22/22"
      priority    = 2
      cidr_ip     = "192.168.0.0/16"
    }
  }
}

# ECS configuration
variable "ecs_instance_type" {
  description = "The instance type for the ECS instance"
  type        = string
  default     = "ecs.t6-c1m2.large"
}

variable "ecs_system_disk_category" {
  description = "The system disk category for the ECS instance"
  type        = string
  default     = "cloud_essd"
}

variable "ecs_instance_password" {
  description = "The password for the ECS instance"
  type        = string
  sensitive   = true
}

variable "ecs_instance_name" {
  description = "The name of the ECS instance"
  type        = string
  default     = "end-to-end-tracing-ecs"
}

variable "ecs_internet_bandwidth" {
  description = "The internet bandwidth for the ECS instance"
  type        = number
  default     = 5
}

# RDS configuration
variable "rds_instance_type" {
  description = "The instance type for the RDS database"
  type        = string
  default     = "mysql.n2.medium.1"
}

variable "rds_instance_storage" {
  description = "The storage size for the RDS instance in GB"
  type        = number
  default     = 50
}

variable "rds_category" {
  description = "The category of the RDS instance"
  type        = string
  default     = "Basic"
}

variable "rds_storage_type" {
  description = "The storage type of the RDS instance"
  type        = string
  default     = "cloud_essd"
}

variable "rds_engine" {
  description = "The database engine of the RDS instance"
  type        = string
  default     = "MySQL"
}

variable "rds_engine_version" {
  description = "The engine version of the RDS instance"
  type        = string
  default     = "8.0"
}

variable "rds_account_type" {
  description = "The account type for the RDS database"
  type        = string
  default     = "Normal"
}

variable "rds_account_name" {
  description = "The account name for the RDS database"
  type        = string
  default     = "db_normal_account"
}

variable "db_password" {
  description = "The account password for the RDS database"
  type        = string
  sensitive   = true
}

variable "rds_account_privilege" {
  description = "The account privilege for the RDS database"
  type        = string
  default     = "ReadWrite"
}

# RDS database configuration
variable "rds_database_character_set" {
  description = "The character set for the RDS database"
  type        = string
  default     = "utf8"
}

variable "rds_database_name" {
  description = "The name of the RDS database"
  type        = string
  default     = "flashsale"
}

# Redis configuration
variable "redis_engine_version" {
  description = "The engine version of the Redis instance"
  type        = string
  default     = "7.0"
}

variable "redis_instance_class" {
  description = "The instance class of the Redis instance"
  type        = string
  default     = "redis.shard.small.2.ce"
}

variable "redis_password" {
  description = "The password for the Redis instance"
  type        = string
  sensitive   = true
}

variable "redis_shard_count" {
  description = "The shard count for the Redis instance"
  type        = number
  default     = 1
}

variable "redis_instance_name" {
  description = "The name of the Redis instance"
  type        = string
  default     = "end-to-end-tracing-redis"
}

# RocketMQ configuration
variable "rocketmq_msg_process_spec" {
  description = "The message processing specification for RocketMQ"
  type        = string
  default     = "rmq.s2.2xlarge"
}

variable "rocketmq_message_retention_time" {
  description = "The message retention time for RocketMQ in hours"
  type        = string
  default     = "70"
}

variable "rocketmq_sub_series_code" {
  description = "The sub-series code for RocketMQ"
  type        = string
  default     = "cluster_ha"
}

variable "rocketmq_series_code" {
  description = "The series code for RocketMQ"
  type        = string
  default     = "standard"
}

variable "rocketmq_payment_type" {
  description = "The payment type for RocketMQ"
  type        = string
  default     = "PayAsYouGo"
}

variable "rocketmq_service_code" {
  description = "The service code for RocketMQ"
  type        = string
  default     = "rmq"
}

variable "rocketmq_instance_name" {
  description = "The name of the RocketMQ instance"
  type        = string
  default     = "end-to-end-tracing-rocketmq"
}

variable "rocketmq_internet_spec" {
  description = "The internet spec for RocketMQ"
  type        = string
  default     = "disable"
}

variable "rocketmq_flow_out_type" {
  description = "The flow out type for RocketMQ"
  type        = string
  default     = "uninvolved"
}

variable "rocketmq_acl_types" {
  description = "The ACL types for RocketMQ"
  type        = list(string)
  default     = ["default", "apache_acl"]
}

variable "rocketmq_default_vpc_auth_free" {
  description = "Whether VPC auth is free for RocketMQ by default"
  type        = bool
  default     = false
}

variable "rocketmq_username" {
  description = "The username for RocketMQ"
  type        = string
  default     = "rmquser"
}

variable "rocketmq_password" {
  description = "The password for RocketMQ"
  type        = string
  sensitive   = true
}

variable "rocketmq_account_status" {
  description = "The account status for RocketMQ"
  type        = string
  default     = "ENABLE"
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
      remark       = "库存系统扣减库存成功后订单创建失败"
      message_type = "NORMAL"
    }
    "order-fail-after-deducted-inventory" = {
      remark       = "预扣库存成功后订单创建失败"
      message_type = "NORMAL"
    }
    "order-success" = {
      remark       = "订单创建成功"
      message_type = "TRANSACTION"
    }
  }
}

# RocketMQ consumer group configuration
variable "rocketmq_consumer_group_id" {
  description = "The consumer group ID for RocketMQ"
  type        = string
  default     = "flashsale-service-consumer-group"
}

variable "rocketmq_delivery_order_type" {
  description = "The delivery order type for RocketMQ consumer group"
  type        = string
  default     = "Concurrently"
}

variable "rocketmq_retry_policy" {
  description = "The retry policy for RocketMQ consumer group"
  type        = string
  default     = "DefaultRetryPolicy"
}

variable "rocketmq_max_retry_times" {
  description = "The maximum retry times for RocketMQ consumer group"
  type        = number
  default     = 5
}

# RocketMQ ACL configuration
variable "rocketmq_topic_actions" {
  description = "The actions for RocketMQ topic ACL"
  type        = list(string)
  default     = ["Pub", "Sub"]
}

variable "rocketmq_group_actions" {
  description = "The actions for RocketMQ group ACL"
  type        = list(string)
  default     = ["Sub"]
}

variable "rocketmq_acl_decision" {
  description = "The decision for RocketMQ ACL"
  type        = string
  default     = "Allow"
}

variable "rocketmq_acl_ip_whitelists" {
  description = "The IP whitelists for RocketMQ ACL"
  type        = list(string)
  default     = ["192.168.0.0/16"]
}

# MSE configuration
variable "mse_version" {
  description = "The version of MSE"
  type        = string
  default     = "mse_dev"
}

variable "mse_instance_count" {
  description = "The instance count for MSE cluster"
  type        = number
  default     = 1
}

variable "mse_cluster_version" {
  description = "The cluster version for MSE"
  type        = string
  default     = "NACOS_2_0_0"
}

variable "mse_cluster_type" {
  description = "The cluster type for MSE"
  type        = string
  default     = "Nacos-Ans"
}

variable "mse_cluster_specification" {
  description = "The cluster specification for MSE"
  type        = string
  default     = "MSE_SC_1_2_60_c"
}

variable "mse_net_type" {
  description = "The network type for MSE"
  type        = string
  default     = "privatenet"
}

variable "mse_pub_network_flow" {
  description = "The public network flow for MSE"
  type        = number
  default     = 0
}

variable "mse_cluster_alias_name" {
  description = "The alias name for MSE cluster"
  type        = string
  default     = "end-to-end-tracing-mse"
}

variable "mse_nacos_endpoint" {
  description = "The Nacos endpoint for MSE"
  type        = string
  default     = "mse-nacos-endpoint"
}

# ECS command configuration
variable "ecs_command_name" {
  description = "The name of the ECS command"
  type        = string
  default     = "end-to-end-tracing-deployment"
}

variable "ecs_command_working_dir" {
  description = "The working directory for the ECS command"
  type        = string
  default     = "/root"
}

variable "ecs_command_type" {
  description = "The type of the ECS command"
  type        = string
  default     = "RunShellScript"
}

variable "ecs_command_timeout" {
  description = "The timeout for the ECS command"
  type        = number
  default     = 3600
}

# ECS invocation configuration
variable "ecs_invocation_timeout" {
  description = "The timeout for the ECS invocation"
  type        = string
  default     = "15m"
}

# License configuration
variable "mse_license_key" {
  description = "The MSE license key"
  type        = string
  sensitive   = true
}

variable "arms_license_key" {
  description = "The ARMS license key"
  type        = string
  sensitive   = true
}

# Custom deployment script (optional)
variable "custom_deployment_script" {
  description = "Optional custom deployment script to override the default script"
  type        = string
  default     = null
}