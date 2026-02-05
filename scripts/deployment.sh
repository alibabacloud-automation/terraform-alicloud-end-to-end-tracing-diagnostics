#!/bin/bash

# End-to-End Tracing and Diagnostics Deployment Script
# This script sets up environment variables and installs monitoring agents

# Set up environment variables
cat << EOT >> ~/.bash_profile
export REGION=${region}
export DB_URL=${db_url}
export DB_USERNAME=${db_username}
export DB_PASSWORD=${db_password}
export REDIS_HOST=${redis_host}
export REDIS_PASSWORD=${redis_password}
export NACOS_URL=${nacos_url}
export ROCKETMQ_ENDPOINT=${rocketmq_endpoint}
export ROCKETMQ_USERNAME=${rocketmq_username}
export ROCKETMQ_PASSWORD=${rocketmq_password}
export MSE_LICENSE_KEY=${mse_license_key}
export ARMS_LICENSE_KEY=${arms_license_key}
EOT

# Source the environment variables
source ~/.bash_profile

# Install ARMS APM agent
curl -fsSL https://help-static-aliyun-doc.aliyuncs.com/install-script/arms-apm/install.sh | bash

echo "Deployment script completed successfully"