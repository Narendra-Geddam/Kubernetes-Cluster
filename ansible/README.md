<div align="center">

<h1>Ansible Kubernetes Bootstrap</h1>

<p><strong>Role-based automation to convert EC2 hosts into working Kubernetes clusters</strong></p>

![Ansible](https://img.shields.io/badge/Ansible-Core-0ea5e9?style=for-the-badge)
![Inventory](https://img.shields.io/badge/Inventory-AWS%20Dynamic-2563eb?style=for-the-badge)
![Kubeadm](https://img.shields.io/badge/Kubeadm-Init%20%2B%20Join-1d4ed8?style=for-the-badge)
![CNI](https://img.shields.io/badge/CNI-Flannel-4338ca?style=for-the-badge)

</div>

---

## What It Does

- validates environment prerequisites (`precheck.yml`)
- prepares all nodes (`bootstrap` role)
- initializes control planes (`control_plane` role)
- joins workers to the correct cluster (`workers` role)

## Prerequisites

```bash
export ANSIBLE_PRIVATE_KEY_FILE=/absolute/path/to/key.pem
ansible-galaxy collection install -r requirements.yml
```

## Run Sequence

```bash
./run-precheck.sh
./run-site.sh
```

## Key Paths

| Path | Purpose |
|---|---|
| `inventory/aws_ec2.yml` | dynamic inventory source |
| `playbooks/precheck.yml` | safety checks |
| `playbooks/site.yml` | orchestrated deployment |
| `roles/*` | role implementations |

## Troubleshooting

- inventory empty: verify AWS credentials and EC2 tags
- SSH failures: confirm `ANSIBLE_PRIVATE_KEY_FILE`
- join issues: run full site playbook in order
