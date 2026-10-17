# AWS Infrastructure with Terraform

Infrastructure as Code (IaC) project that deploys a small, working web environment on AWS: a custom VPC with internet access, a public subnet, an Apache web server on EC2 and a private, encrypted S3 bucket.

## Architecture

```
                Internet
                    │
            ┌───────▼────────┐
            │ Internet GW    │
            └───────┬────────┘
   VPC 10.0.0.0/16  │
   ┌────────────────▼─────────────────┐
   │ Public subnet 10.0.1.0/24        │
   │  ┌────────────────────────────┐  │      ┌──────────────────────┐
   │  │ EC2 (Amazon Linux 2023)    │  │      │ S3 bucket (private)  │
   │  │ Apache · SG: 80 open,      │  │      │ versioning + SSE     │
   │  │ 22 only from trusted IP    │  │      │ public access blocked│
   │  └────────────────────────────┘  │      └──────────────────────┘
   └──────────────────────────────────┘
```

## Technologies

- Terraform (AWS provider 5.x)
- AWS VPC, Subnet, Internet Gateway, Route Table
- AWS EC2 + Security Groups
- AWS S3 (versioning, encryption, public access block)

## What it deploys

1. VPC `10.0.0.0/16` with DNS support
2. Internet Gateway and a public route table (`0.0.0.0/0 → IGW`)
3. Public subnet `10.0.1.0/24` that assigns public IPs on launch
4. EC2 instance (`t2.micro`, latest Amazon Linux 2023 via data source) with Apache installed through `user_data`
5. Security group: HTTP (80) open, **SSH (22) restricted to a single trusted CIDR** (the variable rejects `0.0.0.0/0`)
6. Private S3 bucket with versioning, AES-256 encryption and all public access blocked
7. Outputs: public IP, website URL and bucket name

## Security decisions

| Decision | Why |
|---|---|
| SSH limited to `allowed_ssh_cidr` with validation | Avoids exposing port 22 to the whole internet |
| S3 public access block | Prevents accidental public exposure of files |
| Versioning + SSE on S3 | Recovery from accidental deletions and encryption at rest |
| AMI resolved with a data source | Always uses the latest patched Amazon Linux image |

## Usage

```bash
terraform init
terraform plan  -var="allowed_ssh_cidr=$(curl -s https://checkip.amazonaws.com)/32"
terraform apply -var="allowed_ssh_cidr=$(curl -s https://checkip.amazonaws.com)/32"

# Clean up when finished to avoid costs
terraform destroy -var="allowed_ssh_cidr=$(curl -s https://checkip.amazonaws.com)/32"
```

Requirements: AWS credentials configured locally and an existing EC2 key pair (default name `terraform-key`, change it with `-var="key_name=..."`).

## File structure

```
terraform-aws-basic-infra/
├── provider.tf    # Terraform and provider versions, default tags
├── variables.tf   # Region, instance type, key pair, trusted SSH CIDR
├── main.tf        # VPC, IGW, routing, SG, EC2, S3
├── outputs.tf     # Public IP, URL and bucket name
└── README.md
```

## Possible improvements

- Remote state in S3 with DynamoDB locking
- Split into reusable modules (network / compute / storage)
- Replace SSH with AWS Systems Manager Session Manager
