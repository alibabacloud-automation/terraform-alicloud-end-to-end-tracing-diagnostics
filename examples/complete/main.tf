# Provider configuration
provider "alicloud" {
  region = var.region
}

# Data sources to get available zones and instance types
data "alicloud_zones" "default" {
  available_disk_category     = "cloud_essd"
  available_resource_creation = "VSwitch"
  available_instance_type     = "ecs.t6-c1m2.large"
}

data "alicloud_db_zones" "rds_zones" {
  engine                   = "MySQL"
  engine_version           = "8.0"
  instance_charge_type     = "PostPaid"
  category                 = "Basic"
  db_instance_storage_type = "cloud_essd"
}

data "alicloud_kvstore_zones" "redis_zones" {
  instance_charge_type = "PostPaid"
  engine               = "Redis"
  product_type         = "OnECS"
}

data "alicloud_images" "default" {
  name_regex  = "^aliyun_3_x64_20G_alibase_.*"
  most_recent = true
  owners      = "system"
}

# Call the end-to-end tracing module
module "end_to_end_tracing" {
  source = "../../"

  # VPC configuration
  vpc_config = {
    cidr_block = var.vpc_cidr_block
    vpc_name   = var.vpc_name
  }

  # VSwitch configurations
  vswitch_configs = {
    ecs = {
      cidr_block   = var.ecs_vswitch_cidr_block
      zone_id      = data.alicloud_zones.default.zones[0].id
      vswitch_name = var.ecs_vswitch_name
    }
    rds = {
      cidr_block   = var.rds_vswitch_cidr_block
      zone_id      = data.alicloud_db_zones.rds_zones.zones[0].id
      vswitch_name = var.rds_vswitch_name
    }
    redis = {
      cidr_block   = var.redis_vswitch_cidr_block
      zone_id      = data.alicloud_kvstore_zones.redis_zones.zones[0].id
      vswitch_name = var.redis_vswitch_name
    }
  }

  # Security group configuration
  security_group_config = {
    security_group_name = var.security_group_name
    description         = var.security_group_description
  }

  # Security group rules
  security_group_rules = var.security_group_rules

  # ECS configuration
  ecs_config = {
    image_id                   = data.alicloud_images.default.images[0].id
    instance_type              = var.ecs_instance_type
    system_disk_category       = var.ecs_system_disk_category
    password                   = var.ecs_instance_password
    instance_name              = var.ecs_instance_name
    internet_max_bandwidth_out = var.ecs_internet_bandwidth
  }

  # RDS configuration
  rds_config = {
    instance_type            = var.rds_instance_type
    zone_id                  = data.alicloud_db_zones.rds_zones.zones[0].id
    instance_storage         = var.rds_instance_storage
    category                 = var.rds_category
    db_instance_storage_type = var.rds_storage_type
    engine                   = var.rds_engine
    engine_version           = var.rds_engine_version
    security_ips             = [var.vpc_cidr_block]
  }

  # RDS account configuration
  rds_account_config = {
    account_type     = var.rds_account_type
    account_name     = var.rds_account_name
    account_password = var.db_password
    privilege        = var.rds_account_privilege
  }

  # RDS database configuration
  rds_database_config = {
    character_set = var.rds_database_character_set
    name          = var.rds_database_name
  }

  # Redis configuration
  redis_config = {
    engine_version   = var.redis_engine_version
    zone_id          = data.alicloud_kvstore_zones.redis_zones.zones[0].id
    instance_class   = var.redis_instance_class
    password         = var.redis_password
    shard_count      = var.redis_shard_count
    db_instance_name = var.redis_instance_name
    security_ips     = [var.vpc_cidr_block]
  }

  # RocketMQ configuration
  rocketmq_config = {
    msg_process_spec       = var.rocketmq_msg_process_spec
    message_retention_time = var.rocketmq_message_retention_time
    sub_series_code        = var.rocketmq_sub_series_code
    series_code            = var.rocketmq_series_code
    payment_type           = var.rocketmq_payment_type
    service_code           = var.rocketmq_service_code
    instance_name          = var.rocketmq_instance_name
    internet_spec          = var.rocketmq_internet_spec
    flow_out_type          = var.rocketmq_flow_out_type
    acl_types              = var.rocketmq_acl_types
    default_vpc_auth_free  = var.rocketmq_default_vpc_auth_free
  }

  # RocketMQ account configuration
  rocketmq_account_config = {
    account_status = var.rocketmq_account_status
    username       = var.rocketmq_username
    password       = var.rocketmq_password
  }

  # RocketMQ topics configuration
  rocketmq_topics = var.rocketmq_topics

  # RocketMQ consumer group configuration
  rocketmq_consumer_group_config = {
    consumer_group_id   = var.rocketmq_consumer_group_id
    delivery_order_type = var.rocketmq_delivery_order_type
    retry_policy        = var.rocketmq_retry_policy
    max_retry_times     = var.rocketmq_max_retry_times
  }

  # RocketMQ ACL configuration
  rocketmq_acl_config = {
    topic_actions = var.rocketmq_topic_actions
    group_actions = var.rocketmq_group_actions
    decision      = var.rocketmq_acl_decision
    ip_whitelists = var.rocketmq_acl_ip_whitelists
  }

  # MSE configuration
  mse_config = {
    mse_version           = var.mse_version
    instance_count        = var.mse_instance_count
    cluster_version       = var.mse_cluster_version
    cluster_type          = var.mse_cluster_type
    cluster_specification = var.mse_cluster_specification
    net_type              = var.mse_net_type
    pub_network_flow      = var.mse_pub_network_flow
    cluster_alias_name    = var.mse_cluster_alias_name
    nacos_endpoint        = var.mse_nacos_endpoint
  }

  # ECS command configuration
  ecs_command_config = {
    name        = var.ecs_command_name
    working_dir = var.ecs_command_working_dir
    type        = var.ecs_command_type
    timeout     = var.ecs_command_timeout
  }

  # ECS invocation configuration
  ecs_invocation_config = {
    timeout = var.ecs_invocation_timeout
  }

  # License configuration
  license_config = {
    mse_license_key  = var.mse_license_key
    arms_license_key = var.arms_license_key
  }

  # Custom deployment script (optional)
  custom_deployment_script = var.custom_deployment_script
}