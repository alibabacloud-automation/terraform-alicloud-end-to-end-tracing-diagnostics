# End-to-End Tracing and Diagnostics - Complete Example

This example demonstrates how to use the end-to-end tracing and diagnostics module to deploy a complete infrastructure for distributed application monitoring and tracing.

## Usage

1. **Clone the repository** (if using as a module):
   ```bash
   git clone <repository-url>
   cd terraform-alicloud-end-to-end-tracing/examples/complete
   `````

2. **Initialize and apply**:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

3. **Access the application**:
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

## Cleanup

To destroy the infrastructure:

```bash
terraform destroy
```

**Note**: Ensure you backup any important data before destroying the infrastructure.
