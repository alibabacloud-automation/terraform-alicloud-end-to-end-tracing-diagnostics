# Module outputs
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.end_to_end_tracing.vpc_id
}

output "vswitch_ids" {
  description = "Map of VSwitch IDs"
  value       = module.end_to_end_tracing.vswitch_ids
}

output "ecs_instance_id" {
  description = "The ID of the ECS instance"
  value       = module.end_to_end_tracing.ecs_instance_id
}

output "ecs_public_ip" {
  description = "The public IP address of the ECS instance"
  value       = module.end_to_end_tracing.ecs_public_ip
}

output "rds_instance_id" {
  description = "The ID of the RDS instance"
  value       = module.end_to_end_tracing.rds_instance_id
}

output "rds_connection_string" {
  description = "The connection string of the RDS instance"
  value       = module.end_to_end_tracing.rds_connection_string
}

output "redis_instance_id" {
  description = "The ID of the Redis instance"
  value       = module.end_to_end_tracing.redis_instance_id
}

output "redis_connection_domain" {
  description = "The connection domain of the Redis instance"
  value       = module.end_to_end_tracing.redis_connection_domain
}

output "rocketmq_instance_id" {
  description = "The ID of the RocketMQ instance"
  value       = module.end_to_end_tracing.rocketmq_instance_id
}

output "mse_cluster_id" {
  description = "The ID of the MSE cluster"
  value       = module.end_to_end_tracing.mse_cluster_id
}

output "web_url" {
  description = "The URL to access the deployed application"
  value       = module.end_to_end_tracing.web_url
}

output "ecs_login_url" {
  description = "The URL to login to the ECS instance via workbench"
  value       = module.end_to_end_tracing.ecs_login_url
}