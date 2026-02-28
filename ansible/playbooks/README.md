<div align="center">

<h1>Playbook Orchestration</h1>

<p><strong>Execution order and role responsibilities for reproducible Kubernetes bring-up</strong></p>

![Precheck](https://img.shields.io/badge/Stage-Precheck-0ea5e9?style=for-the-badge)
![Bootstrap](https://img.shields.io/badge/Stage-Bootstrap-2563eb?style=for-the-badge)
![ControlPlane](https://img.shields.io/badge/Stage-Control%20Plane-1d4ed8?style=for-the-badge)
![Workers](https://img.shields.io/badge/Stage-Workers-4338ca?style=for-the-badge)

</div>

---

## Playbooks

| Playbook | Purpose |
|---|---|
| `precheck.yml` | Validate key env vars, inventory visibility, and host readiness |
| `site.yml` | Execute full cluster build workflow |

## Flow

1. run precheck to fail fast
2. apply bootstrap role to all nodes
3. initialize control plane nodes
4. join workers using generated join tokens

## Commands

```bash
ansible-playbook -i inventory/aws_ec2.yml playbooks/precheck.yml
ansible-playbook -i inventory/aws_ec2.yml playbooks/site.yml
```

Wrapper scripts:

```bash
./run-precheck.sh
./run-site.sh
```

## Design Notes

- role order is intentional and should not be shuffled
- control plane facts are used to join workers correctly
- most tasks are idempotent and safe to rerun
