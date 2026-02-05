# 端到端全链路追踪诊断解决方案 Terraform 模块

================================================ 

terraform-alicloud-end-to-end-tracing-diagnostics

[English](https://github.com/terraform-alicloud-modules/terraform-alicloud-end-to-end-tracing-diagnostics/blob/master/README.md) | 简体中文

在阿里云上创建完整的端到端全链路追踪诊断基础设施的 Terraform 模块。该模块提供 VPC、ECS、RDS MySQL、Redis、RocketMQ、MSE Nacos 集群以及监控组件，用于支持分布式应用的可观测性和性能监控。

## 使用方法

该模块创建端到端应用追踪和诊断的综合基础设施，包括分布式系统监控、消息队列、服务发现和数据持久化所需的所有组件。

```terraform
# 获取可用区和镜像信息的数据源
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

  # 通用配置
  common_config = {
    name_prefix = "my-tracing-solution"
    region      = "cn-hangzhou"
  }

  # VPC 配置
  vpc_config = {
    cidr_block = "192.168.0.0/16"
  }

  # 交换机配置
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

  # ECS 配置
  ecs_config = {
    image_id                   = data.alicloud_images.default.images[0].id
    instance_type              = "ecs.t6-c1m2.large"
    system_disk_category       = "cloud_essd"
    password                   = "YourSecurePassword123!"
    internet_max_bandwidth_out = 5
  }

  # RDS 配置
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

  # RDS 账号配置
  rds_account_config = {
    account_type     = "Normal"
    account_name     = "db_normal_account"
    account_password = "YourDBPassword123!"
    privilege        = "ReadWrite"
  }

  # Redis 配置
  redis_config = {
    engine_version = "7.0"
    zone_id        = data.alicloud_kvstore_zones.redis_zones.zones[0].id
    instance_class = "redis.shard.small.2.ce"
    password       = "YourRedisPassword123!"
    shard_count    = 1
    security_ips   = ["192.168.0.0/16"]
  }

  # RocketMQ 配置
  rocketmq_config = {
    msg_process_spec       = "rmq.s2.2xlarge"
    message_retention_time = "70"
    sub_series_code        = "cluster_ha"
    series_code            = "standard"
    payment_type           = "PayAsYouGo"
    service_code           = "rmq"
  }

  # RocketMQ 账号配置
  rocketmq_account_config = {
    account_status = "ENABLE"
    username       = "rmquser"
    password       = "YourRocketMQPassword123!"
  }

  # MSE 配置
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

  # 许可证配置
  license_config = {
    mse_license_key  = "your-mse-license-key"
    arms_license_key = "your-arms-license-key"
  }
}
```

## 示例

* [完整示例](https://github.com/alibabacloud-automation/terraform-alicloud-end-to-end-tracing-diagnostics/tree/main/examples/complete)

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->

## 提交问题

如果您在使用此模块时遇到任何问题，请提交一个 [provider issue](https://github.com/aliyun/terraform-provider-alicloud/issues/new) 并告知我们。

**注意：** 不建议在此仓库中提交问题。

## 作者

由阿里云 Terraform 团队创建和维护(terraform@alibabacloud.com)。

## 许可证

MIT 许可。有关完整详细信息，请参阅 LICENSE。

## 参考

* [Terraform-Provider-Alicloud Github](https://github.com/aliyun/terraform-provider-alicloud)
* [Terraform-Provider-Alicloud Release](https://releases.hashicorp.com/terraform-provider-alicloud/)
* [Terraform-Provider-Alicloud Docs](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs)