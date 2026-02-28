<div align="center">

<h1>AWS Dynamic Inventory</h1>

<p><strong>Tag-driven host discovery for multi-cluster automation</strong></p>

![Plugin](https://img.shields.io/badge/Plugin-amazon.aws.aws__ec2-0ea5e9?style=for-the-badge)
![Source](https://img.shields.io/badge/Source-EC2%20API-2563eb?style=for-the-badge)
![Grouping](https://img.shields.io/badge/Grouping-Cluster%20%2B%20Role-1d4ed8?style=for-the-badge)
![User](https://img.shields.io/badge/SSH%20User-ec2--user-4338ca?style=for-the-badge)

</div>

---

## File

- `aws_ec2.yml`

## How Hosts Are Grouped

Instances are filtered to running EC2 nodes, then grouped by tags:

- `cluster_*` from `Cluster`
- `role_*` from `Role`

## Required Tags

- `Cluster`: `Dev/Test Cluster` or `Production Cluster`
- `Role`: control plane / worker role labels

## Validate Inventory

```bash
ansible-inventory -i inventory/aws_ec2.yml --graph
```

or

```bash
./run-inventory.sh
```

## Expected Outcome

Inventory graph should show cluster and role groups with matching hosts.
