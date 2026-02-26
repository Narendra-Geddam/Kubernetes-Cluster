<div align="center">

# Mini-Project: Dual Kubernetes Clusters on AWS

### Terraform-provisioned infrastructure with Ansible-driven Kubernetes bootstrap

![Terraform](https://img.shields.io/badge/Terraform-Infrastructure-0f172a?style=for-the-badge)
![Ansible](https://img.shields.io/badge/Ansible-Automation-1e293b?style=for-the-badge)
![Kubernetes](https://img.shields.io/badge/Kubernetes-Dual%20Cluster-334155?style=for-the-badge)
![AWS](https://img.shields.io/badge/AWS-EC2%20%2B%20VPC-475569?style=for-the-badge)

</div>

---

## Objective

Provision AWS infrastructure and configure two Kubernetes clusters:

- Dev/Test Cluster: 1 control plane + 2 workers
- Production Cluster: 1 control plane + 2 workers

---

## Architecture Summary

- Terraform creates VPC, subnets, routing, security group, and EC2 nodes.
- Ansible discovers nodes with AWS dynamic inventory (EC2 tags).
- Ansible bootstraps container runtime and Kubernetes components.
- Control planes are initialized and workers join automatically by cluster grouping.

---

## Project Folders

- `infra/` - Terraform code and state for AWS provisioning
- `ansible/` - Dynamic inventory, playbooks, and cluster configuration flow

---

## Run Order

```bash
cd infra
terraform init
terraform plan
terraform apply

cd ../ansible
ansible-galaxy collection install -r requirements.yml
./run-inventory.sh
./run-site.sh
```

---

## Associated Documentation

- `infra/README.md`
- `infra/COMMANDS_AND_ISSUES.md`
- `ansible/README.md`
- `ansible/COMMANDS_AND_ISSUES.md`
- `ansible/NEW_INFRA_ROLE_APPLY_GUIDE.md`
- `ansible/playbooks/README.md`
- `ansible/inventory/README.md`

---

## Final Status

- Infrastructure provisioning design: COMPLETE
- Kubernetes automation workflow: COMPLETE
- Folder-level documentation coverage: COMPLETE
# Kubernetes-Cluster
