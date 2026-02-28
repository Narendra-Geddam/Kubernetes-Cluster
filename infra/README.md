<div align="center">

<h1>Terraform AWS Infrastructure</h1>

<p><strong>Base network and compute layer for KubeCoin clusters</strong></p>

![Terraform](https://img.shields.io/badge/Terraform-v1.14%2B-0ea5e9?style=for-the-badge)
![VPC](https://img.shields.io/badge/AWS-VPC-2563eb?style=for-the-badge)
![EC2](https://img.shields.io/badge/EC2-6%20Nodes-1d4ed8?style=for-the-badge)
![Tags](https://img.shields.io/badge/Tags-Ansible%20Discovery-4338ca?style=for-the-badge)

</div>

---

## Provisions

- 1 VPC
- 2 public subnets across AZs
- internet gateway + route table
- security group for SSH + intra-cluster communication
- 6 EC2 instances (Dev/Test + Production)

## Core Files

| File | Purpose |
|---|---|
| `provider.tf` | provider configuration |
| `variables.tf` | inputs |
| `main.tf` | resources |
| `outputs.tf` | output values |

## Run

```bash
terraform init
terraform plan
terraform apply
```

## Destroy

```bash
terraform destroy
```

## Critical Inputs

- `aws_region`
- `key_name`
- `ssh_cidr`
- instance types for control plane and workers

## Important Outputs

- control plane public IPs
- VPC and subnet IDs
- cluster node mapping
