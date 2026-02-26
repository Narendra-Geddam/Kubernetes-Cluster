<div align="center">

# Terraform Infrastructure Stack

### Network and compute layer for Dev/Test and Production Kubernetes clusters

![Terraform](https://img.shields.io/badge/Terraform-v1.14%2B-0f172a?style=for-the-badge)
![AWS VPC](https://img.shields.io/badge/AWS-VPC%20%2B%20Subnets-1e293b?style=for-the-badge)
![EC2](https://img.shields.io/badge/EC2-6%20Nodes-334155?style=for-the-badge)
![Security](https://img.shields.io/badge/Security-SSH%20%2B%20IntraSG-475569?style=for-the-badge)

</div>

---

## Objective

Create the AWS base infrastructure required for Ansible to configure both Kubernetes clusters.

---

## Resources Created

- 1 VPC (`10.0.0.0/16` by default)
- 2 public subnets in separate AZs
- Internet Gateway + public route table
- 1 shared security group for node communication
- 6 EC2 instances total:
- Dev/Test: control plane + worker 1 + worker 2
- Production: control plane + worker 1 + worker 2

---

## Files

- `provider.tf`
- `variables.tf`
- `terraform.tfvars`
- `main.tf`
- `outputs.tf`

---

## Deploy

```bash
cd infra
terraform init
terraform plan
terraform apply
```

---

## Destroy

```bash
cd infra
terraform destroy
```

---

## Important Inputs

- `aws_region`
- `control_plane_instance_type`
- `worker_instance_type`
- `ssh_cidr`
- `key_name`

---

## Important Outputs

- `vpc_id`
- `subnet_ids`
- `cluster_nodes`
- `devtest_control_plane_public_ip`
- `production_control_plane_public_ip`

---

## Final Status

- Networking layer: DEFINED
- Compute layer: DEFINED
- Tagging for Ansible dynamic inventory: ENABLED

---

## Command And Issue Log

- `COMMANDS_AND_ISSUES.md` (full destroy/recreate command history and issue resolutions)
