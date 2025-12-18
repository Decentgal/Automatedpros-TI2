# AWS High Availability Infrastructure (AutomatedPros Project 2)

A Terraform-managed project that deploys a self-healing, highly available web architecture on AWS.

##  What this project does?
This project automates the creation of a secure network and compute layer designed for zero downtime. If a server fails, the system automatically replaces it.

##  Key Features
* **High Availability:** Deployed across two Availability Zones (Subnet A and Subnet B).
* **Self-Healing:** Uses an **Auto Scaling Group** to monitor server health and replace terminated instances.
* **Traffic Management:** An **Application Load Balancer** (ALB) distributes incoming web traffic to healthy instances.
* **Infrastructure as Code:** 100% automated using Terraform for consistent deployments.

##  Architecture
* **VPC & Networking:** Custom VPC with public subnets and an Internet Gateway.
* **Security:** Security Groups configured to allow HTTP traffic only on Port 80.
* **Compute:** EC2 instances launched via a Launch Template with Apache installed.

# How to Deploy the Terraform
1. Initialize Terraform: `terraform init`
2. Preview the build: `terraform plan`
3. Deploy to AWS: `terraform apply --auto-approve`
4. Access the site via the Load Balancer DNS output.