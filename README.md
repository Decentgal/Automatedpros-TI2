# AWS High Availability Infrastructure (AutomatedPros Project 2)

A Terraform-managed project that deploys a self-healing, highly available web architecture on AWS.

##  What this project does?
This project automates the creation of a secure network and compute layer designed for zero downtime. If a server fails, the system automatically replaces it.

##  Key Features
* **High Availability:** Deployed across two Availability Zones (Subnet A and Subnet B).
* **Self-Healing:** Uses an **Auto Scaling Group** to monitor server health and replace terminated instances.
* <img width="1365" height="767" alt="high-availa" src="https://github.com/user-attachments/assets/d19c470c-e9fc-4500-9635-0caa5003fe65" />

* * <img width="1365" height="631" alt="apros-final" src="https://github.com/user-attachments/assets/e1091927-d295-4329-a161-fdff077980d5" />
* **Traffic Management:** An **Application Load Balancer** (ALB) distributes incoming web traffic to healthy instances.
* **Infrastructure as Code:** 100% automated using Terraform for consistent deployments and saved state on Terraform Cloud.
* <img width="1365" height="767" alt="12" src="https://github.com/user-attachments/assets/604225c0-9214-45ea-bc2b-1455f6935567" />

* <img width="1364" height="717" alt="11" src="https://github.com/user-attachments/assets/d1b71264-cca4-445f-b0d8-6a6ecfe540ea" />


##  Architecture
* **VPC & Networking:** Custom VPC with public subnets and an Internet Gateway.
* **Security:** Security Groups configured to allow HTTP traffic only on Port 80.
* **Compute:** EC2 instances launched via a Launch Template with Apache installed.

# How to Deploy the Terraform
1. Initialize Terraform: `terraform init`
2. Preview the build: `terraform plan`
3. Deploy to AWS: `terraform apply --auto-approve`
4. Access the site via the Load Balancer DNS record
<img width="1365" height="724" alt="111" src="https://github.com/user-attachments/assets/fe516fce-be0a-4aa5-b5ac-676d83f75bf5" />

