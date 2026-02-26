<div align="center">

# Ansible Kubernetes Configuration

### Dynamic AWS inventory and automated kubeadm cluster bring-up

![Ansible](https://img.shields.io/badge/Ansible-Playbook%20Flow-0f172a?style=for-the-badge)
![Inventory](https://img.shields.io/badge/Inventory-Dynamic%20EC2-1e293b?style=for-the-badge)
![Kubeadm](https://img.shields.io/badge/Kubeadm-Bootstrap%20%2B%20Join-334155?style=for-the-badge)
![CNI](https://img.shields.io/badge/CNI-Flannel-475569?style=for-the-badge)

</div>

---

## Objective

Configure EC2 nodes into two working Kubernetes clusters after Terraform provisioning.

Target layout:

- Dev/Test Cluster: 1 control plane + 2 workers
- Production Cluster: 1 control plane + 2 workers

---

## Prerequisites

- `../infra` already applied
- AWS credentials available
- SSH key exported:

```bash
export ANSIBLE_PRIVATE_KEY_FILE=/absolute/path/to/Ansible.pem
```

---

## Files

- `ansible.cfg`
- `requirements.yml`
- `inventory/aws_ec2.yml`
- `group_vars/all.yml`
- `playbooks/site.yml`
- `playbooks/bootstrap.yml`
- `playbooks/control_plane.yml`
- `playbooks/workers.yml`
- `run-inventory.sh`
- `run-site.sh`

---

## Deploy

```bash
cd ansible
ansible-galaxy collection install -r requirements.yml
./run-inventory.sh
./run-site.sh
```

---

## Verify

```bash
cd ansible
./run-inventory.sh
ansible-inventory -i inventory/aws_ec2.yml --graph
```

Expected groups include:

- `cluster_Dev_Test_Cluster`
- `cluster_Production_Cluster`
- `role_Control_Plane_Node`
- `role_Worker_Node_1`
- `role_Worker_Node_2`

---

## Common Problems Faced

1. `Permission denied (publickey)`
- Cause: invalid or missing `ANSIBLE_PRIVATE_KEY_FILE`
- Fix: export a valid PEM path and retry

2. Dynamic inventory returns empty
- Cause: missing AWS credentials or region/tag mismatch
- Fix: verify creds and confirm EC2 tags `Cluster` and `Role`

3. Worker join fails
- Cause: control plane not initialized yet
- Fix: run full `site.yml` flow to preserve task order

---

## Final Status

- Dynamic inventory wiring: READY
- Playbook orchestration: READY
- Multi-cluster bootstrap flow: READY
