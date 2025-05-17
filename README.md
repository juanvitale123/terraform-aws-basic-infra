# 🚀 AWS Infrastructure with Terraform

This project automates the deployment of a basic infrastructure on AWS using Terraform. It includes a VPC, public subnet, EC2 instance with Apache, a security group, and an S3 bucket — all managed as code (IaC).

---

## 🧰 Technologies Used

- Terraform
- AWS EC2
- AWS S3
- AWS VPC & Subnets
- Security Groups

---

## 🛠️ What It Deploys

1. A custom VPC with CIDR block `10.0.0.0/16`
2. A public subnet in `us-east-1a`
3. An EC2 instance (`t2.micro`) with Apache pre-installed via `user_data`
4. A security group allowing SSH (22) and HTTP (80)
5. A private S3 bucket for static files
6. Outputs: public IP of EC2 and bucket name

---

## 🗂️ File Structure

```bash
terraform-aws-basic-infra/
├── main.tf         # Resources: VPC, Subnet, EC2, SG, S3
├── provider.tf     # AWS provider configuration
├── variables.tf    # Input variables (region, instance type)
├── outputs.tf      # Useful outputs like public IP
├── README.md       # This documentation
