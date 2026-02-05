# Terraform Module for End-to-End Tracing and Diagnostics Solution

================================================ 

terraform-alicloud-end-to-end-tracing-diagnostics

English | [简体中文](https://github.com/terraform-alicloud-modules/terraform-alicloud-end-to-end-tracing-diagnostics/blob/master/README-CN.md)

Terraform module which creates a complete end-to-end tracing and diagnostics infrastructure on Alibaba Cloud. This module provisions VPC, ECS, RDS MySQL, Redis, RocketMQ, MSE Nacos cluster, and monitoring components to support distributed application observability and performance monitoring.

## Usage

This module creates a comprehensive infrastructure for end-to-end application tracing and diagnostics, including all necessary components for distributed system monitoring, message queuing, service discovery, and data persistence.

```terraform
# Data sources for availability zones and images
data "alicloud_zones" "default" {
  available_disk_category     = "cloud_essd"
  available_resource_creation = "VSwitch"
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

module "end_to_end_tracing" {
  source = "alibabacloud-automation/end-to-end-tracing-diagnostics/alicloud"

  # Common configuration
  common_config = {
    name_prefix = "my-tracing-solution"
    region      = "cn-hangzhou"
  }

  # VPC configuration
  vpc_config = {
    cidr_block = "192.168.0.0/16"
  }

  # VSwitch configurations
  vswitch_configs = {
    ecs = {
      cidr_block = "192.168.1.0/24"
      zone_id    = data.alicloud_zones.default.zones[0].id
    }
    rds = {
      cidr_block = "192.168.2.0/24"
      zone_id    = data.alicloud_db_zones.rds_zones.zones[0].id
    }
    redis = {
      cidr_block = "192.168.3.0/24"
      zone_id    = data.alicloud_kvstore_zones.redis_zones.zones[0].id
    }
  }

  # ECS configuration
  ecs_config = {
    image_id                   = data.alicloud_images.default.images[0].id
    instance_type              = "ecs.t6-c1m2.large"
    system_disk_category       = "cloud_essd"
    password                   = "YourSecurePassword123!"
    internet_max_bandwidth_out = 5
  }

  # RDS configuration
  rds_config = {
    instance_type            = "mysql.n2.medium.1"
    zone_id                  = data.alicloud_db_zones.rds_zones.zones[0].id
    instance_storage         = 50
    category                 = "Basic"
    db_instance_storage_type = "cloud_essd"
    engine                   = "MySQL"
    engine_version           = "8.0"
    security_ips             = ["192.168.0.0/16"]
  }

  # RDS account configuration
  rds_account_config = {
    account_type     = "Normal"
    account_name     = "db_normal_account"
    account_password = "YourDBPassword123!"
    privilege        = "ReadWrite"
  }

  # Redis configuration
  redis_config = {
    engine_version = "7.0"
    zone_id        = data.alicloud_kvstore_zones.redis_zones.zones[0].id
    instance_class = "redis.shard.small.2.ce"
    password       = "YourRedisPassword123!"
    shard_count    = 1
    security_ips   = ["192.168.0.0/16"]
  }

  # RocketMQ configuration
  rocketmq_config = {
    msg_process_spec       = "rmq.s2.2xlarge"
    message_retention_time = "70"
    sub_series_code        = "cluster_ha"
    series_code            = "standard"
    payment_type           = "PayAsYouGo"
    service_code           = "rmq"
  }

  # RocketMQ account configuration
  rocketmq_account_config = {
    account_status = "ENABLE"
    username       = "rmquser"
    password       = "YourRocketMQPassword123!"
  }

  # MSE configuration
  mse_config = {
    mse_version           = "mse_dev"
    instance_count        = 1
    cluster_version       = "NACOS_2_0_0"
    cluster_type          = "Nacos-Ans"
    cluster_specification = "MSE_SC_1_2_60_c"
    net_type              = "privatenet"
    pub_network_flow      = 0
    nacos_endpoint        = "nacos-endpoint-placeholder"
  }

  # License configuration
  license_config = {
    mse_license_key  = "your-mse-license-key"
    arms_license_key = "your-arms-license-key"
  }
}
```

## Examples

* [Complete Example](https://github.com/alibabacloud-automation/terraform-alicloud-end-to-end-tracing-diagnostics/tree/main/examples/complete)

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->

## Submit Issues

If you have any problems when using this module, please opening
a [provider issue](https://github.com/aliyun/terraform-provider-alicloud/issues/new) and let us know.

**Note:** There does not recommend opening an issue on this repo.

## Authors

Created and maintained by Alibaba Cloud Terraform Team(terraform@alibabacloud.com).

## License

MIT Licensed. See LICENSE for full details.

## Reference

* [Terraform-Provider-Alicloud Github](https://github.com/aliyun/terraform-provider-alicloud)
* [Terraform-Provider-Alicloud Release](https://releases.hashicorp.com/terraform-provider-alicloud/)
* [Terraform-Provider-Alicloud Docs](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs)