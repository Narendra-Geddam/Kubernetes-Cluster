<div align="center">

# AWS Dynamic Inventory

### Tag-driven host grouping for multi-cluster Ansible execution

![Plugin](https://img.shields.io/badge/Plugin-amazon.aws.aws__ec2-0f172a?style=for-the-badge)
![Grouping](https://img.shields.io/badge/Groups-Cluster%20%2B%20Role-1e293b?style=for-the-badge)
![Connection](https://img.shields.io/badge/SSH-ec2--user-334155?style=for-the-badge)
![Source](https://img.shields.io/badge/Source-EC2%20Tags-475569?style=for-the-badge)

</div>

---

## Objective

Discover running EC2 instances and build role/cluster groups automatically from tags.

---

## File

- `aws_ec2.yml`

---

## Grouping Rules

- Instances filtered by:
- `instance-state-name = running`
- `tag:Cluster in [Dev/Test Cluster, Production Cluster]`

Keyed groups created from tags:

- `cluster_*` from EC2 `Cluster`
- `role_*` from EC2 `Role`

---

## Host Composition

- `ansible_host = public_ip_address`
- `ansible_user = ec2-user`
- `ansible_ssh_private_key_file` from `ANSIBLE_PRIVATE_KEY_FILE`

---

## Validate

```bash
cd ansible
ansible-inventory -i inventory/aws_ec2.yml --graph
```

Or:

```bash
./run-inventory.sh
```

---

## Final Status

- EC2 discovery: ACTIVE
- Cluster group mapping: ACTIVE
- Role group mapping: ACTIVE
