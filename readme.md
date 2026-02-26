# AWS/Terraform High Availability Architecture

This repository contains Terraform code to set up a high availability architecture on AWS. The architecture includes multiple availability zones, load balancers, and auto-scaling groups to ensure that the application remains available even in the event of a failure.

## Architecture Overview

The architecture consists of the following components:

1. **VPC**: A Virtual Private Cloud to host all the resources.
2. **Subnets**: Multiple subnets across different availability zones for high availability.
3. **Internet Gateway**: To allow internet access to the resources.
4. **Route Tables**: To manage the routing of traffic within the VPC.
5. **Security Groups**: To control inbound and outbound traffic to the resources.
6. **Load Balancer**: An Application Load Balancer to distribute traffic across multiple instances.
7. **Auto Scaling Group**: To automatically scale the number of instances based on demand.
8. **EC2 Instances**: The compute resources that will run the application.

## Prerequisites

- An AWS account
- Terraform installed on your local machine
- AWS CLI configured with your credentials
