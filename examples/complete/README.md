# End-to-End Tracing and Diagnostics - Complete Example

This example demonstrates how to use the end-to-end tracing and diagnostics module to deploy a complete infrastructure for distributed application monitoring and tracing.

## Architecture Overview

This example creates:

- **VPC and Network**: A VPC with multiple VSwitches for different components
- **ECS Instance**: A compute instance for running the application
- **RDS MySQL**: A managed MySQL database for data storage
- **Redis**: A managed Redis instance for caching
- **RocketMQ**: A message queue service for async communication
- **MSE Nacos**: A service registry and configuration center
- **RAM User**: An IAM user with necessary permissions
- **Monitoring Setup**: Automated deployment of ARMS and MSE monitoring agents

## Prerequisites

1. **Alibaba Cloud Account**: Ensure you have an active Alibaba Cloud account
2. **License Keys**: Obtain the following license keys:
   - MSE License Key from [MSE Console](https://mse.console.aliyun.com)
   - ARMS License Key from [ARMS Console](https://arms.console.aliyun.com)
3. **Terraform**: Install Terraform >= 1.0
4. **Alibaba Cloud Provider**: Configure the Alibaba Cloud provider credentials

## Usage

1. **Clone the repository** (if using as a module):
   ```bash
   git clone <repository-url>
   cd terraform-alicloud-end-to-end-tracing/examples/complete
   ```

2. **Configure variables**:
   Create a `terraform.tfvars` file with your specific values:
   ```hcl
   # Basic configuration
   region      = "cn-hangzhou"
   name_prefix = "my-tracing-solution"
   
   # Network configuration
   vpc_cidr_block           = "192.168.0.0/16"
   ecs_vswitch_cidr_block   = "192.168.1.0/24"
   rds_vswitch_cidr_block   = "192.168.2.0/24"
   redis_vswitch_cidr_block = "192.168.3.0/24"
   
   # Instance passwords (required)
   ecs_instance_password = "YourSecurePassword123!"
   rds_account_password  = "YourDBPassword123!"
   redis_password        = "YourRedisPassword123!"
   rocketmq_password     = "YourRocketMQPassword123!"
   
   # License keys (required)
   mse_license_key  = "your-mse-license-key"
   arms_license_key = "your-arms-license-key"
   ```

3. **Initialize and apply**:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

4. **Access the application**:
   After deployment, use the output URLs to access your application and monitoring interfaces.

## Configuration

### Required Variables

- `ecs_instance_password`: Password for the ECS instance
- `rds_account_password`: Password for the RDS database account
- `redis_password`: Password for the Redis instance
- `rocketmq_password`: Password for the RocketMQ instance
- `mse_license_key`: License key for MSE services
- `arms_license_key`: License key for ARMS monitoring

### Optional Variables

All other variables have sensible defaults but can be customized:

- **Instance Types**: Adjust `ecs_instance_type`, `rds_instance_type`, `redis_instance_class` for your performance needs
- **Network Configuration**: Modify CIDR blocks if needed
- **Storage**: Configure `rds_instance_storage` based on your data requirements

## Outputs

This example provides several useful outputs:

- `web_url`: Direct URL to access the deployed application
- `ecs_login_url`: URL to access the ECS instance via Alibaba Cloud console
- `vpc_id`, `ecs_instance_id`, `rds_instance_id`: Resource IDs for reference
- Connection strings and endpoints for all services

## Security Considerations

1. **Passwords**: Use strong passwords and consider using Alibaba Cloud KMS for encryption
2. **Network Security**: The default security group allows HTTP traffic; customize as needed
3. **Access Control**: The created RAM user has LogFullAccess; adjust permissions as required
4. **License Keys**: Store license keys securely and avoid committing them to version control

## Monitoring and Observability

Once deployed, the infrastructure includes:

- **ARMS APM**: Automatic application performance monitoring
- **MSE Governance**: Service mesh and microservice governance
- **RocketMQ Monitoring**: Message queue performance tracking
- **Database Monitoring**: RDS and Redis performance metrics

Access the monitoring dashboards through the Alibaba Cloud console using the provided URLs.

## Cleanup

To destroy the infrastructure:

```bash
terraform destroy
```

**Note**: Ensure you backup any important data before destroying the infrastructure.

## Troubleshooting

### Common Issues

1. **Zone Availability**: If resources fail to create due to zone constraints, the module will automatically select available zones
2. **Instance Type Availability**: Ensure the selected instance types are available in your chosen region
3. **License Key Issues**: Verify that your MSE and ARMS license keys are valid and active

### Getting Help

- Check the [Alibaba Cloud Documentation](https://www.alibabacloud.com/help)
- Review the Terraform Alibaba Cloud Provider documentation
- Examine the module source code for detailed resource configurations

## License

This example is provided under the same license as the parent module.