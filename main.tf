# End-to-End Tracing and Diagnostics Solution Module
# This module creates a complete infrastructure for end-to-end tracing and diagnostics
# including VPC, ECS, RDS, Redis, RocketMQ, and MSE components

# Data sources for region and account information
data "alicloud_regions" "current" {
  current = true
}

# Local variables for common naming and configuration
locals {
  default_deployment_script = <<-EOT
#!/bin/bash

# Set up environment variables
cat << EOF >> ~/.bash_profile
export REGION=${data.alicloud_regions.current.regions[0].id}
export DB_URL=${alicloud_db_instance.rds_instance.connection_string}:3306/${alicloud_db_database.rds_database.data_base_name}
export DB_USERNAME=${alicloud_rds_account.rds_account.account_name}
export DB_PASSWORD=${alicloud_rds_account.rds_account.account_password}
export REDIS_HOST=${alicloud_kvstore_instance.redis_instance.connection_domain}
export REDIS_PASSWORD=${alicloud_kvstore_instance.redis_instance.password}
export NACOS_URL=${data.alicloud_mse_clusters.mse_micro_registry_instance.clusters[0].intranet_domain}:8848
export ROCKETMQ_ENDPOINT=${alicloud_rocketmq_instance.rocketmq.network_info[0].endpoints[0].endpoint_url}
export ROCKETMQ_USERNAME=${alicloud_rocketmq_account.rocketmq_account.username}
export ROCKETMQ_PASSWORD=${alicloud_rocketmq_account.rocketmq_account.password}
export MSE_LICENSE_KEY=${var.license_config.mse_license_key}
export ARMS_LICENSE_KEY=${var.license_config.arms_license_key}
EOF

# Source the environment variables
source ~/.bash_profile

# Install ARMS APM agent
curl -fsSL https://help-static-aliyun-doc.aliyuncs.com/install-script/arms-apm/install.sh | bash

echo "Deployment script completed successfully"
EOT

}

# Create VPC for the infrastructure
resource "alicloud_vpc" "vpc" {
  cidr_block = var.vpc_config.cidr_block
  vpc_name   = var.vpc_config.vpc_name
}

# Create VSwitches for different components
resource "alicloud_vswitch" "vswitches" {
  for_each = var.vswitch_configs

  vpc_id       = alicloud_vpc.vpc.id
  cidr_block   = each.value.cidr_block
  zone_id      = each.value.zone_id
  vswitch_name = each.value.vswitch_name
}

# Create security group for ECS instances
resource "alicloud_security_group" "security_group" {
  vpc_id              = alicloud_vpc.vpc.id
  security_group_name = var.security_group_config.security_group_name
  description         = var.security_group_config.description
}

# Create security group rules
resource "alicloud_security_group_rule" "security_group_rules" {
  for_each = var.security_group_rules

  type              = each.value.type
  ip_protocol       = each.value.ip_protocol
  nic_type          = each.value.nic_type
  policy            = each.value.policy
  port_range        = each.value.port_range
  priority          = each.value.priority
  security_group_id = alicloud_security_group.security_group.id
  cidr_ip           = each.value.cidr_ip
}


# Create ECS instance
resource "alicloud_instance" "ecs_instance" {
  instance_name              = var.ecs_config.instance_name
  image_id                   = var.ecs_config.image_id
  instance_type              = var.ecs_config.instance_type
  system_disk_category       = var.ecs_config.system_disk_category
  security_groups            = [alicloud_security_group.security_group.id]
  vswitch_id                 = alicloud_vswitch.vswitches["ecs"].id
  password                   = var.ecs_config.password
  internet_max_bandwidth_out = var.ecs_config.internet_max_bandwidth_out
}

# Create RDS instance
resource "alicloud_db_instance" "rds_instance" {
  instance_type            = var.rds_config.instance_type
  zone_id                  = var.rds_config.zone_id
  instance_storage         = var.rds_config.instance_storage
  category                 = var.rds_config.category
  db_instance_storage_type = var.rds_config.db_instance_storage_type
  vswitch_id               = alicloud_vswitch.vswitches["rds"].id
  engine                   = var.rds_config.engine
  vpc_id                   = alicloud_vpc.vpc.id
  engine_version           = var.rds_config.engine_version
  security_ips             = var.rds_config.security_ips
}

# Create RDS account
resource "alicloud_rds_account" "rds_account" {
  db_instance_id   = alicloud_db_instance.rds_instance.id
  account_type     = var.rds_account_config.account_type
  account_name     = var.rds_account_config.account_name
  account_password = var.rds_account_config.account_password
}

# Create RDS database
resource "alicloud_db_database" "rds_database" {
  character_set  = var.rds_database_config.character_set
  instance_id    = alicloud_db_instance.rds_instance.id
  data_base_name = var.rds_database_config.name
}

# Grant database privileges to RDS account
resource "alicloud_db_account_privilege" "account_privilege" {
  privilege    = var.rds_account_config.privilege
  instance_id  = alicloud_db_instance.rds_instance.id
  account_name = alicloud_rds_account.rds_account.account_name
  db_names     = [alicloud_db_database.rds_database.data_base_name]
}

# Create Redis instance
resource "alicloud_kvstore_instance" "redis_instance" {
  engine_version   = var.redis_config.engine_version
  zone_id          = var.redis_config.zone_id
  vswitch_id       = alicloud_vswitch.vswitches["redis"].id
  instance_class   = var.redis_config.instance_class
  password         = var.redis_config.password
  shard_count      = var.redis_config.shard_count
  db_instance_name = var.redis_config.db_instance_name
  security_ips     = var.redis_config.security_ips
}

# Create RocketMQ instance
resource "alicloud_rocketmq_instance" "rocketmq" {
  product_info {
    msg_process_spec       = var.rocketmq_config.msg_process_spec
    message_retention_time = var.rocketmq_config.message_retention_time
  }

  sub_series_code = var.rocketmq_config.sub_series_code
  series_code     = var.rocketmq_config.series_code
  payment_type    = var.rocketmq_config.payment_type
  instance_name   = var.rocketmq_config.instance_name
  service_code    = var.rocketmq_config.service_code

  network_info {
    vpc_info {
      vpc_id = alicloud_vpc.vpc.id
      vswitches {
        vswitch_id = alicloud_vswitch.vswitches["ecs"].id
      }
    }
    internet_info {
      internet_spec = var.rocketmq_config.internet_spec
      flow_out_type = var.rocketmq_config.flow_out_type
    }
  }

  acl_info {
    acl_types             = var.rocketmq_config.acl_types
    default_vpc_auth_free = var.rocketmq_config.default_vpc_auth_free
  }
}

# Create RocketMQ account
resource "alicloud_rocketmq_account" "rocketmq_account" {
  account_status = var.rocketmq_account_config.account_status
  instance_id    = alicloud_rocketmq_instance.rocketmq.id
  username       = var.rocketmq_account_config.username
  password       = var.rocketmq_account_config.password
}

# Create RocketMQ topics
resource "alicloud_rocketmq_topic" "topics" {
  for_each = var.rocketmq_topics

  instance_id  = alicloud_rocketmq_instance.rocketmq.id
  remark       = each.value.remark
  message_type = each.value.message_type
  topic_name   = each.key
}

# Create RocketMQ consumer group
resource "alicloud_rocketmq_consumer_group" "consumer_group" {
  consumer_group_id   = var.rocketmq_consumer_group_config.consumer_group_id
  instance_id         = alicloud_rocketmq_instance.rocketmq.id
  delivery_order_type = var.rocketmq_consumer_group_config.delivery_order_type

  consume_retry_policy {
    retry_policy    = var.rocketmq_consumer_group_config.retry_policy
    max_retry_times = var.rocketmq_consumer_group_config.max_retry_times
  }
}

# Create RocketMQ ACL rules for topics
resource "alicloud_rocketmq_acl" "topic_acls" {
  for_each = var.rocketmq_topics

  actions       = var.rocketmq_acl_config.topic_actions
  instance_id   = alicloud_rocketmq_instance.rocketmq.id
  username      = alicloud_rocketmq_account.rocketmq_account.username
  resource_name = each.key
  resource_type = "Topic"
  decision      = var.rocketmq_acl_config.decision
  ip_whitelists = var.rocketmq_acl_config.ip_whitelists

  depends_on = [alicloud_rocketmq_topic.topics]
}

# Create RocketMQ ACL rule for consumer group
resource "alicloud_rocketmq_acl" "consumer_group_acl" {
  actions       = var.rocketmq_acl_config.group_actions
  instance_id   = alicloud_rocketmq_instance.rocketmq.id
  username      = alicloud_rocketmq_account.rocketmq_account.username
  resource_name = alicloud_rocketmq_consumer_group.consumer_group.consumer_group_id
  resource_type = "Group"
  decision      = var.rocketmq_acl_config.decision
  ip_whitelists = var.rocketmq_acl_config.ip_whitelists
}

# Create MSE cluster (Nacos)
resource "alicloud_mse_cluster" "mse_cluster" {
  vpc_id                = alicloud_vpc.vpc.id
  vswitch_id            = alicloud_vswitch.vswitches["ecs"].id
  mse_version           = var.mse_config.mse_version
  instance_count        = var.mse_config.instance_count
  cluster_version       = var.mse_config.cluster_version
  cluster_type          = var.mse_config.cluster_type
  cluster_specification = var.mse_config.cluster_specification
  net_type              = var.mse_config.net_type
  pub_network_flow      = var.mse_config.pub_network_flow
  cluster_alias_name    = var.mse_config.cluster_alias_name
}

data "alicloud_mse_clusters" "mse_micro_registry_instance" {
  enable_details = "true"
  ids            = [alicloud_mse_cluster.mse_cluster.id]
}

# Create cloud assistant command for application deployment
resource "alicloud_ecs_command" "deployment_command" {
  name = var.ecs_command_config.name
  command_content = base64encode(
    var.custom_deployment_script != null ? var.custom_deployment_script : local.default_deployment_script
  )
  working_dir = var.ecs_command_config.working_dir
  type        = var.ecs_command_config.type
  timeout     = var.ecs_command_config.timeout
}

# Execute the deployment command on ECS instance
resource "alicloud_ecs_invocation" "deployment_invocation" {
  instance_id = [alicloud_instance.ecs_instance.id]
  command_id  = alicloud_ecs_command.deployment_command.id

  timeouts {
    create = var.ecs_invocation_config.timeout
  }

  depends_on = [
    alicloud_rocketmq_acl.topic_acls,
    alicloud_rocketmq_acl.consumer_group_acl,
  ]
}