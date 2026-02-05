# VPC outputs
output "vpc_id" {
  description = "The ID of the VPC"
  value       = alicloud_vpc.vpc.id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = alicloud_vpc.vpc.cidr_block
}

# VSwitch outputs
output "vswitch_ids" {
  description = "Map of VSwitch IDs"
  value       = { for k, v in alicloud_vswitch.vswitches : k => v.id }
}

# Security group outputs
output "security_group_id" {
  description = "The ID of the security group"
  value       = alicloud_security_group.security_group.id
}


# ECS instance outputs
output "ecs_instance_id" {
  description = "The ID of the ECS instance"
  value       = alicloud_instance.ecs_instance.id
}

output "ecs_public_ip" {
  description = "The public IP address of the ECS instance"
  value       = alicloud_instance.ecs_instance.public_ip
}

output "ecs_private_ip" {
  description = "The private IP address of the ECS instance"
  value       = alicloud_instance.ecs_instance.primary_ip_address
}

# RDS outputs
output "rds_instance_id" {
  description = "The ID of the RDS instance"
  value       = alicloud_db_instance.rds_instance.id
}

output "rds_connection_string" {
  description = "The connection string of the RDS instance"
  value       = alicloud_db_instance.rds_instance.connection_string
}

output "rds_database_name" {
  description = "The name of the RDS database"
  value       = alicloud_db_database.rds_database.data_base_name
}

output "rds_account_name" {
  description = "The name of the RDS account"
  value       = alicloud_rds_account.rds_account.account_name
}

# Redis outputs
output "redis_instance_id" {
  description = "The ID of the Redis instance"
  value       = alicloud_kvstore_instance.redis_instance.id
}

output "redis_connection_domain" {
  description = "The connection domain of the Redis instance"
  value       = alicloud_kvstore_instance.redis_instance.connection_domain
}

# RocketMQ outputs
output "rocketmq_instance_id" {
  description = "The ID of the RocketMQ instance"
  value       = alicloud_rocketmq_instance.rocketmq.id
}

output "rocketmq_endpoints" {
  description = "The endpoints of the RocketMQ instance"
  value       = alicloud_rocketmq_instance.rocketmq.network_info[0].endpoints
}

output "rocketmq_account_username" {
  description = "The username of the RocketMQ account"
  value       = alicloud_rocketmq_account.rocketmq_account.username
}

output "rocketmq_topic_names" {
  description = "List of RocketMQ topic names"
  value       = [for topic in alicloud_rocketmq_topic.topics : topic.topic_name]
}

output "rocketmq_consumer_group_id" {
  description = "The ID of the RocketMQ consumer group"
  value       = alicloud_rocketmq_consumer_group.consumer_group.consumer_group_id
}

# MSE cluster outputs
output "mse_cluster_id" {
  description = "The ID of the MSE cluster"
  value       = alicloud_mse_cluster.mse_cluster.id
}

output "mse_cluster_alias_name" {
  description = "The alias name of the MSE cluster"
  value       = alicloud_mse_cluster.mse_cluster.cluster_alias_name
}

# ECS command outputs
output "ecs_command_id" {
  description = "The ID of the ECS command"
  value       = alicloud_ecs_command.deployment_command.id
}

output "ecs_invocation_id" {
  description = "The ID of the ECS invocation"
  value       = alicloud_ecs_invocation.deployment_invocation.id
}

# Application access outputs
output "web_url" {
  description = "The URL to access the deployed application"
  value       = "http://${alicloud_instance.ecs_instance.public_ip}"
}

output "ecs_login_url" {
  description = "The URL to login to the ECS instance via workbench"
  value       = "https://ecs-workbench.aliyun.com/?from=ecs&instanceType=ecs&regionId=${data.alicloud_regions.current.regions[0].id}&instanceId=${alicloud_instance.ecs_instance.id}&resourceGroupId="
}