<div align="center">

# Reusable Role Apply Guide

### Commands and prerequisites to run roles on any new infrastructure

![Guide](https://img.shields.io/badge/Guide-New%20Infra%20Apply-0f172a?style=for-the-badge)
![Precheck](https://img.shields.io/badge/Precheck-Required-1e293b?style=for-the-badge)
![Roles](https://img.shields.io/badge/Mode-Role%20Based-334155?style=for-the-badge)
![AWS](https://img.shields.io/badge/Target-EC2%20Tags-475569?style=for-the-badge)

</div>

---

## Required Infrastructure Conditions

- All target instances must be `running`.
- Nodes must be Amazon Linux compatible with current tasks.
- Security group rules must allow:
- SSH (`22/tcp`) from your operator IP.
- Full traffic inside the node security group (self-reference).
- Outbound internet access (for repos and CNI download).

---

## Required EC2 Tags

Every node must have:

- `Cluster`: `Dev/Test Cluster` or `Production Cluster`
- `Role`: `Control Plane Node`, `Worker Node 1`, or `Worker Node 2`

Expected counts:

- 2 control planes total (1 per cluster)
- 4 workers total (2 per cluster)

---

## Local Machine Prerequisites

```bash
# 1) AWS credentials
aws sts get-caller-identity

# 2) Python dependencies for dynamic inventory
python3 -m pip install --user boto3 botocore

# 3) Ansible collection
cd ansible
ansible-galaxy collection install -r requirements.yml -p collections

# 4) SSH key for target instances
chmod 400 /absolute/path/to/Ansible.pem
export ANSIBLE_PRIVATE_KEY_FILE=/absolute/path/to/Ansible.pem

# 5) Region (optional override; default eu-north-1)
export AWS_REGION=eu-north-1
```

---

## Mandatory Precheck Before Apply

```bash
cd ansible
./run-precheck.sh
```

This validates:

- local dependencies (`ansible`, `boto3`, `botocore`)
- key presence/readability
- dynamic inventory resolution
- SSH reachability for all nodes
- required role and cluster group counts

---

## Apply Roles

```bash
cd ansible
./run-site.sh
```

---

## Post-Apply Verification

```bash
# Dev/Test control plane
ssh -F /dev/null -i "$ANSIBLE_PRIVATE_KEY_FILE" ec2-user@<devtest_control_plane_public_ip> \
  "kubectl get nodes -o wide"

# Production control plane
ssh -F /dev/null -i "$ANSIBLE_PRIVATE_KEY_FILE" ec2-user@<production_control_plane_public_ip> \
  "kubectl get nodes -o wide"
```

Both clusters should show 3 `Ready` nodes each.
