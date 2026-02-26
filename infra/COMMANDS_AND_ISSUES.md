<div align="center">

# Terraform Commands And Issues Log

### Full destroy and recreate execution record

![Terraform](https://img.shields.io/badge/Terraform-Execution%20Log-0f172a?style=for-the-badge)
![Destroy](https://img.shields.io/badge/Phase-Destroy-1e293b?style=for-the-badge)
![Recreate](https://img.shields.io/badge/Phase-Recreate-334155?style=for-the-badge)
![AWS](https://img.shields.io/badge/AWS-eu--north--1-475569?style=for-the-badge)

</div>

---

## Commands Executed

```bash
# Setup / validation
cd infra
cp -n terraform.tfvars.example terraform.tfvars
terraform fmt -check -recursive

# Initialization
terraform init -input=false
terraform validate

# Destroy checks
terraform plan -destroy -input=false
terraform destroy -auto-approve -input=false

# First create attempt
terraform plan -input=false
terraform apply -auto-approve -input=false

# State/infra inspection after failed apply
terraform state list
aws ec2 describe-instances --region eu-north-1 \
  --filters "Name=tag:Cluster,Values=Dev/Test Cluster,Production Cluster" \
            "Name=instance-state-name,Values=pending,running,stopping,stopped" \
  --query "Reservations[].Instances[].{Id:InstanceId,State:State.Name,Cluster:Tags[?Key=='Cluster']|[0].Value,Role:Tags[?Key=='Role']|[0].Value,Type:InstanceType}" \
  --output table

# Full cleanup for "destroy all infra"
aws ec2 terminate-instances --region eu-north-1 --instance-ids <all-cluster-instance-ids>
aws ec2 wait instance-terminated --region eu-north-1 --instance-ids <all-cluster-instance-ids>
terraform destroy -auto-approve -input=false
aws ec2 describe-vpcs --region eu-north-1 --filters "Name=tag:Name,Values=AWS VPC" \
  --query "Vpcs[].{VpcId:VpcId,Cidr:CidrBlock,State:State,Default:IsDefault}" --output table

# Manual unmanaged VPC cleanup (old orphaned stack)
aws ec2 describe-internet-gateways ...
aws ec2 detach-internet-gateway ...
aws ec2 delete-internet-gateway ...
aws ec2 describe-route-tables ...
aws ec2 disassociate-route-table ...
aws ec2 delete-route-table ...
aws ec2 describe-subnets ...
aws ec2 delete-subnet ...
aws ec2 describe-security-groups ...
aws ec2 delete-security-group ...
aws ec2 delete-vpc --region eu-north-1 --vpc-id <orphan-vpc-id>

# Recreate clean infrastructure
aws ec2 describe-instances --region eu-north-1 --filters "Name=tag:Cluster,Values=Dev/Test Cluster,Production Cluster" ...
aws ec2 describe-vpcs --region eu-north-1 --filters "Name=tag:Name,Values=AWS VPC" ...
terraform apply -auto-approve -input=false
```

---

## Issues Faced

1. `terraform init` failed in sandbox network mode
- Error: could not connect to `registry.terraform.io`
- Resolution: reran with elevated network-enabled execution.

2. `terraform validate` plugin schema load failed in sandbox
- Error: provider plugin handshake / schema load failure.
- Resolution: reran with elevated execution.

3. First `terraform apply` failed with `VcpuLimitExceeded`
- Error: AWS EC2 quota exceeded while creating production nodes.
- Root cause: old unmanaged cluster instances were still running.
- Resolution:
  - terminated all old and partial cluster instances by tag,
  - destroyed managed partial stack,
  - removed orphan old VPC resources manually,
  - reapplied Terraform from clean state.

---

## Final Outcome

- Old infra: destroyed (including orphaned resources).
- New infra: created successfully.
- Final Terraform apply result: `14 added, 0 changed, 0 destroyed`.
