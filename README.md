Terraform Module for End-to-End Tracing and Diagnostics Solution

# terraform-alicloud-end-to-end-tracing-diagnostics

English | [简体中文](https://github.com/alibabacloud-automation/terraform-alicloud-end-to-end-tracing-diagnostics/blob/main/README-CN.md)

This module implements the [end-to-end-tracing-and-diagnostics](https://www.aliyun.com/solution/tech-solution/end-to-end-tracing-and-diagnostics) solution, a comprehensive distributed system monitoring solution that encompasses the creation and deployment of resources such as Virtual Private Cloud (VPC), VSwitch, Elastic Compute Service (ECS), Relational Database Service (RDS), Cache Database (Redis), Message Queue (RocketMQ), and Microservices Engine (MSE). It aims to help users quickly establish a distributed application architecture with full-chain tracing, performance monitoring, and fault diagnosis capabilities.

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

  # VPC configuration
  vpc_config = {
    cidr_block = "192.168.0.0/16"
    vpc_name   = "my-tracing-vpc"
  }

  # VSwitch configurations
  vswitch_configs = {
    ecs = {
      cidr_block   = "192.168.1.0/24"
      zone_id      = data.alicloud_zones.default.zones[0].id
      vswitch_name = "my-tracing-ecs-vsw"
    }
    rds = {
      cidr_block   = "192.168.2.0/24"
      zone_id      = data.alicloud_db_zones.rds_zones.zones[0].id
      vswitch_name = "my-tracing-rds-vsw"
    }
    redis = {
      cidr_block   = "192.168.3.0/24"
      zone_id      = data.alicloud_kvstore_zones.redis_zones.zones[0].id
      vswitch_name = "my-tracing-redis-vsw"
    }
  }

  # Security group configuration
  security_group_config = {
    security_group_name = "my-tracing-security-group"
    description         = "Security group for end-to-end tracing solution"
  }

  # ECS configuration
  ecs_config = {
    image_id                   = data.alicloud_images.default.images[0].id
    instance_type              = "ecs.t6-c1m2.large"
    system_disk_category       = "cloud_essd"
    password                   = "YourSecurePassword123!"
    internet_max_bandwidth_out = 5
    instance_name              = "my-tracing-ecs-instance"
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

  # RDS database configuration
  rds_database_config = {
    character_set = "utf8"
    name          = "flashsale"
  }

  # Redis configuration
  redis_config = {
    engine_version   = "7.0"
    zone_id          = data.alicloud_kvstore_zones.redis_zones.zones[0].id
    instance_class   = "redis.shard.small.2.ce"
    password         = "YourRedisPassword123!"
    shard_count      = 1
    db_instance_name = "my-tracing-redis"
    security_ips     = ["192.168.0.0/16"]
  }

  # RocketMQ configuration
  rocketmq_config = {
    msg_process_spec       = "rmq.s2.2xlarge"
    message_retention_time = "70"
    sub_series_code        = "cluster_ha"
    series_code            = "standard"
    payment_type           = "PayAsYouGo"
    service_code           = "rmq"
    instance_name          = "my-tracing-rocketmq"
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
    cluster_alias_name    = "my-tracing-mse-cluster"
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
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_alicloud"></a> [alicloud](#requirement\_alicloud) | >= 1.212.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_alicloud"></a> [alicloud](#provider\_alicloud) | >= 1.212.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [alicloud_db_account_privilege.account_privilege](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/db_account_privilege) | resource |
| [alicloud_db_database.rds_database](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/db_database) | resource |
| [alicloud_db_instance.rds_instance](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/db_instance) | resource |
| [alicloud_ecs_command.deployment_command](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/ecs_command) | resource |
| [alicloud_ecs_invocation.deployment_invocation](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/ecs_invocation) | resource |
| [alicloud_instance.ecs_instance](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/instance) | resource |
| [alicloud_kvstore_instance.redis_instance](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/kvstore_instance) | resource |
| [alicloud_mse_cluster.mse_cluster](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/mse_cluster) | resource |
| [alicloud_rds_account.rds_account](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/rds_account) | resource |
| [alicloud_rocketmq_account.rocketmq_account](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/rocketmq_account) | resource |
| [alicloud_rocketmq_acl.consumer_group_acl](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/rocketmq_acl) | resource |
| [alicloud_rocketmq_acl.topic_acls](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/rocketmq_acl) | resource |
| [alicloud_rocketmq_consumer_group.consumer_group](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/rocketmq_consumer_group) | resource |
| [alicloud_rocketmq_instance.rocketmq](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/rocketmq_instance) | resource |
| [alicloud_rocketmq_topic.topics](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/rocketmq_topic) | resource |
| [alicloud_security_group.security_group](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/security_group) | resource |
| [alicloud_security_group_rule.security_group_rules](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/security_group_rule) | resource |
| [alicloud_vpc.vpc](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/vpc) | resource |
| [alicloud_vswitch.vswitches](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/vswitch) | resource |
| [alicloud_mse_clusters.mse_micro_registry_instance](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/data-sources/mse_clusters) | data source |
| [alicloud_regions.current](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/data-sources/regions) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_custom_deployment_script"></a> [custom\_deployment\_script](#input\_custom\_deployment\_script) | Optional custom deployment script to override the default script | `string` | `null` | no |
| <a name="input_ecs_command_config"></a> [ecs\_command\_config](#input\_ecs\_command\_config) | ECS cloud assistant command configuration | <pre>object({<br/>    name        = optional(string)<br/>    working_dir = string<br/>    type        = string<br/>    timeout     = number<br/>  })</pre> | <pre>{<br/>  "timeout": 3600,<br/>  "type": "RunShellScript",<br/>  "working_dir": "/root"<br/>}</pre> | no |
| <a name="input_ecs_config"></a> [ecs\_config](#input\_ecs\_config) | ECS instance configuration. The attributes 'image\_id', 'instance\_type', 'system\_disk\_category', 'password' are required. | <pre>object({<br/>    image_id                   = string<br/>    instance_type              = string<br/>    system_disk_category       = string<br/>    password                   = string<br/>    instance_name              = optional(string)<br/>    internet_max_bandwidth_out = optional(number, 5)<br/>  })</pre> | n/a | yes |
| <a name="input_ecs_invocation_config"></a> [ecs\_invocation\_config](#input\_ecs\_invocation\_config) | ECS command invocation configuration | <pre>object({<br/>    timeout = string<br/>  })</pre> | <pre>{<br/>  "timeout": "15m"<br/>}</pre> | no |
| <a name="input_license_config"></a> [license\_config](#input\_license\_config) | License keys configuration for MSE and ARMS. Both 'mse\_license\_key' and 'arms\_license\_key' are required. | <pre>object({<br/>    mse_license_key  = string<br/>    arms_license_key = string<br/>  })</pre> | n/a | yes |
| <a name="input_mse_config"></a> [mse\_config](#input\_mse\_config) | MSE cluster configuration. The attributes 'mse\_version', 'instance\_count', 'cluster\_version', 'cluster\_type', 'cluster\_specification', 'net\_type', 'pub\_network\_flow' are required. | <pre>object({<br/>    mse_version           = string<br/>    instance_count        = number<br/>    cluster_version       = string<br/>    cluster_type          = string<br/>    cluster_specification = string<br/>    net_type              = string<br/>    pub_network_flow      = number<br/>    cluster_alias_name    = optional(string)<br/>    nacos_endpoint        = string<br/>  })</pre> | n/a | yes |
| <a name="input_rds_account_config"></a> [rds\_account\_config](#input\_rds\_account\_config) | RDS account configuration. The attributes 'account\_name', 'account\_password' are required. | <pre>object({<br/>    account_type     = string<br/>    account_name     = string<br/>    account_password = string<br/>    privilege        = string<br/>  })</pre> | <pre>{<br/>  "account_name": null,<br/>  "account_password": null,<br/>  "account_type": "Normal",<br/>  "privilege": "ReadWrite"<br/>}</pre> | no |
| <a name="input_rds_config"></a> [rds\_config](#input\_rds\_config) | RDS database instance configuration. The attributes 'instance\_type', 'zone\_id', 'instance\_storage', 'category', 'db\_instance\_storage\_type', 'engine', 'engine\_version' are required. | <pre>object({<br/>    instance_type            = string<br/>    zone_id                  = string<br/>    instance_storage         = number<br/>    category                 = string<br/>    db_instance_storage_type = string<br/>    engine                   = string<br/>    engine_version           = string<br/>    security_ips             = list(string)<br/>  })</pre> | <pre>{<br/>  "category": "Basic",<br/>  "db_instance_storage_type": "cloud_essd",<br/>  "engine": "MySQL",<br/>  "engine_version": "8.0",<br/>  "instance_storage": 50,<br/>  "instance_type": null,<br/>  "security_ips": [<br/>    "192.168.0.0/16"<br/>  ],<br/>  "zone_id": null<br/>}</pre> | no |
| <a name="input_rds_database_config"></a> [rds\_database\_config](#input\_rds\_database\_config) | RDS database configuration | <pre>object({<br/>    character_set = string<br/>    name          = string<br/>  })</pre> | <pre>{<br/>  "character_set": "utf8",<br/>  "name": "flashsale"<br/>}</pre> | no |
| <a name="input_redis_config"></a> [redis\_config](#input\_redis\_config) | Redis instance configuration. The attributes 'engine\_version', 'zone\_id', 'instance\_class', 'password' are required. | <pre>object({<br/>    engine_version   = string<br/>    zone_id          = string<br/>    instance_class   = string<br/>    password         = string<br/>    shard_count      = optional(number, 1)<br/>    db_instance_name = optional(string)<br/>    security_ips     = optional(list(string), ["192.168.0.0/16"])<br/>  })</pre> | n/a | yes |
| <a name="input_rocketmq_account_config"></a> [rocketmq\_account\_config](#input\_rocketmq\_account\_config) | RocketMQ account configuration. The attributes 'username', 'password' are required. | <pre>object({<br/>    account_status = string<br/>    username       = string<br/>    password       = string<br/>  })</pre> | <pre>{<br/>  "account_status": "ENABLE",<br/>  "password": null,<br/>  "username": null<br/>}</pre> | no |
| <a name="input_rocketmq_acl_config"></a> [rocketmq\_acl\_config](#input\_rocketmq\_acl\_config) | RocketMQ ACL configuration | <pre>object({<br/>    topic_actions = list(string)<br/>    group_actions = list(string)<br/>    decision      = string<br/>    ip_whitelists = list(string)<br/>  })</pre> | <pre>{<br/>  "decision": "Allow",<br/>  "group_actions": [<br/>    "Sub"<br/>  ],<br/>  "ip_whitelists": [<br/>    "192.168.0.0/16"<br/>  ],<br/>  "topic_actions": [<br/>    "Pub",<br/>    "Sub"<br/>  ]<br/>}</pre> | no |
| <a name="input_rocketmq_config"></a> [rocketmq\_config](#input\_rocketmq\_config) | RocketMQ instance configuration. The attributes 'msg\_process\_spec', 'message\_retention\_time', 'sub\_series\_code', 'series\_code', 'payment\_type', 'service\_code' are required. | <pre>object({<br/>    msg_process_spec       = string<br/>    message_retention_time = string<br/>    sub_series_code        = string<br/>    series_code            = string<br/>    payment_type           = string<br/>    service_code           = string<br/>    instance_name          = optional(string)<br/>    internet_spec          = optional(string, "disable")<br/>    flow_out_type          = optional(string, "uninvolved")<br/>    acl_types              = optional(list(string), ["default", "apache_acl"])<br/>    default_vpc_auth_free  = optional(bool, false)<br/>  })</pre> | n/a | yes |
| <a name="input_rocketmq_consumer_group_config"></a> [rocketmq\_consumer\_group\_config](#input\_rocketmq\_consumer\_group\_config) | RocketMQ consumer group configuration | <pre>object({<br/>    consumer_group_id   = string<br/>    delivery_order_type = string<br/>    retry_policy        = string<br/>    max_retry_times     = number<br/>  })</pre> | <pre>{<br/>  "consumer_group_id": "flashsale-service-consumer-group",<br/>  "delivery_order_type": "Concurrently",<br/>  "max_retry_times": 5,<br/>  "retry_policy": "DefaultRetryPolicy"<br/>}</pre> | no |
| <a name="input_rocketmq_topics"></a> [rocketmq\_topics](#input\_rocketmq\_topics) | Map of RocketMQ topics configuration | <pre>map(object({<br/>    remark       = string<br/>    message_type = string<br/>  }))</pre> | <pre>{<br/>  "order-fail-after-deducted-inventory": {<br/>    "message_type": "NORMAL",<br/>    "remark": "Order creation failed after inventory deduction success"<br/>  },<br/>  "order-fail-after-pre-deducted-inventory": {<br/>    "message_type": "NORMAL",<br/>    "remark": "Order creation failed after pre-deducted inventory success"<br/>  },<br/>  "order-success": {<br/>    "message_type": "TRANSACTION",<br/>    "remark": "Order creation success"<br/>  }<br/>}</pre> | no |
| <a name="input_security_group_config"></a> [security\_group\_config](#input\_security\_group\_config) | Security group configuration settings | <pre>object({<br/>    security_group_name = optional(string, null)<br/>    description         = optional(string, "Security group for end-to-end tracing solution")<br/>  })</pre> | <pre>{<br/>  "description": "Security group for end-to-end tracing solution"<br/>}</pre> | no |
| <a name="input_security_group_rules"></a> [security\_group\_rules](#input\_security\_group\_rules) | Map of security group rules configuration | <pre>map(object({<br/>    type        = string<br/>    ip_protocol = string<br/>    nic_type    = string<br/>    policy      = string<br/>    port_range  = string<br/>    priority    = number<br/>    cidr_ip     = string<br/>  }))</pre> | <pre>{<br/>  "allow_web": {<br/>    "cidr_ip": "0.0.0.0/0",<br/>    "ip_protocol": "tcp",<br/>    "nic_type": "intranet",<br/>    "policy": "accept",<br/>    "port_range": "80/80",<br/>    "priority": 1,<br/>    "type": "ingress"<br/>  }<br/>}</pre> | no |
| <a name="input_vpc_config"></a> [vpc\_config](#input\_vpc\_config) | VPC configuration settings. The attribute 'cidr\_block' is required. | <pre>object({<br/>    cidr_block = string<br/>    vpc_name   = optional(string)<br/>  })</pre> | n/a | yes |
| <a name="input_vswitch_configs"></a> [vswitch\_configs](#input\_vswitch\_configs) | Map of VSwitch configurations for different components (ecs, rds, redis) | <pre>map(object({<br/>    cidr_block   = string<br/>    zone_id      = string<br/>    vswitch_name = optional(string)<br/>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ecs_command_id"></a> [ecs\_command\_id](#output\_ecs\_command\_id) | The ID of the ECS command |
| <a name="output_ecs_instance_id"></a> [ecs\_instance\_id](#output\_ecs\_instance\_id) | The ID of the ECS instance |
| <a name="output_ecs_invocation_id"></a> [ecs\_invocation\_id](#output\_ecs\_invocation\_id) | The ID of the ECS invocation |
| <a name="output_ecs_login_url"></a> [ecs\_login\_url](#output\_ecs\_login\_url) | The URL to login to the ECS instance via workbench |
| <a name="output_ecs_private_ip"></a> [ecs\_private\_ip](#output\_ecs\_private\_ip) | The private IP address of the ECS instance |
| <a name="output_ecs_public_ip"></a> [ecs\_public\_ip](#output\_ecs\_public\_ip) | The public IP address of the ECS instance |
| <a name="output_mse_cluster_alias_name"></a> [mse\_cluster\_alias\_name](#output\_mse\_cluster\_alias\_name) | The alias name of the MSE cluster |
| <a name="output_mse_cluster_id"></a> [mse\_cluster\_id](#output\_mse\_cluster\_id) | The ID of the MSE cluster |
| <a name="output_rds_account_name"></a> [rds\_account\_name](#output\_rds\_account\_name) | The name of the RDS account |
| <a name="output_rds_connection_string"></a> [rds\_connection\_string](#output\_rds\_connection\_string) | The connection string of the RDS instance |
| <a name="output_rds_database_name"></a> [rds\_database\_name](#output\_rds\_database\_name) | The name of the RDS database |
| <a name="output_rds_instance_id"></a> [rds\_instance\_id](#output\_rds\_instance\_id) | The ID of the RDS instance |
| <a name="output_redis_connection_domain"></a> [redis\_connection\_domain](#output\_redis\_connection\_domain) | The connection domain of the Redis instance |
| <a name="output_redis_instance_id"></a> [redis\_instance\_id](#output\_redis\_instance\_id) | The ID of the Redis instance |
| <a name="output_rocketmq_account_username"></a> [rocketmq\_account\_username](#output\_rocketmq\_account\_username) | The username of the RocketMQ account |
| <a name="output_rocketmq_consumer_group_id"></a> [rocketmq\_consumer\_group\_id](#output\_rocketmq\_consumer\_group\_id) | The ID of the RocketMQ consumer group |
| <a name="output_rocketmq_endpoints"></a> [rocketmq\_endpoints](#output\_rocketmq\_endpoints) | The endpoints of the RocketMQ instance |
| <a name="output_rocketmq_instance_id"></a> [rocketmq\_instance\_id](#output\_rocketmq\_instance\_id) | The ID of the RocketMQ instance |
| <a name="output_rocketmq_topic_names"></a> [rocketmq\_topic\_names](#output\_rocketmq\_topic\_names) | List of RocketMQ topic names |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | The ID of the security group |
| <a name="output_vpc_cidr_block"></a> [vpc\_cidr\_block](#output\_vpc\_cidr\_block) | The CIDR block of the VPC |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC |
| <a name="output_vswitch_ids"></a> [vswitch\_ids](#output\_vswitch\_ids) | Map of VSwitch IDs |
| <a name="output_web_url"></a> [web\_url](#output\_web\_url) | The URL to access the deployed application |
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