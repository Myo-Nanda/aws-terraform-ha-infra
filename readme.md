# AWS/Terraform High Availability Architecture

This repository contains Terraform code to set up a high availability architecture on AWS. The architecture includes multiple availability zones, load balancers, and auto-scaling groups to ensure that the application remains available even in the event of a failure.

## Architecture Overview

The architecture consists of the following components:

1. **VPC**: A Virtual Private Cloud to host all the resources.
2. **Subnets**: Multiple Public and Private subnets across different availability zones for high availability.
3. **Internet Gateway**: To allow internet access to the resources. inside Public Subnet.
4. **NAT Gateway**: To allow internet access to resources inside Private Subnet.
5. **Route Tables**: To manage the routing of traffic within the VPC.
6. **Security Groups**: To control inbound and outbound traffic to the resources.
7. **Load Balancer**: An Application Load Balancer to distribute traffic across multiple instances.
8. **Auto Scaling Group**: To automatically scale the number of instances based on demand.

## Folder Structure

├── custome_script.sh
├── main.tf
├── modules
│   ├── ASG
│   │   ├── main.tf
│   │   ├── output.tf
│   │   ├── readme.md
│   │   └── variables.tf
│   ├── instance
│   │   ├── main.tf
│   │   ├── output.tf
│   │   └── variables.tf
│   ├── loadblancer
│   │   ├── main.tf
│   │   ├── output.tf
│   │   ├── readme.md
│   │   └── variables.tf
│   ├── security_group
│   │   ├── main.tf
│   │   ├── output.tf
│   │   ├── readme.md
│   │   └── variables.tf
│   └── vpc
│       ├── main.tf
│       ├── output.tf
│       ├── readme.md
│       └── variables.tf
├── readme.md

## Prerequisites

- An AWS account
- Terraform installed on your local machine
- AWS CLI configured with your credentials

## Usage

1. Clone the repository:

```bash
   git clone https://github.com/myonanda/aws-terraform-ha-infra
```

2. Navigate to the project directory:

```bash
   cd aws-terraform-ha-infra
```

3. Initialize Terraform:

```bash
   terraform init
```

4. Review the Terraform plan:

```bash
   terraform plan
```

5. Apply the Terraform configuration:

```bash
   terraform apply
```

6. To destroy the infrastructure when it's no longer needed:

```bash
   terraform destroy
```

## Contributing

Contributions are welcome! Please feel free to submit a pull request or open an issue if you have any suggestions or improvements.
