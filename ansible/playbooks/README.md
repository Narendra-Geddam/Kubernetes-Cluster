<div align="center">

# Kubernetes Playbook Workflow

### Bootstrap nodes, initialize control planes, and join workers

![Bootstrap](https://img.shields.io/badge/Stage%201-Bootstrap-0f172a?style=for-the-badge)
![Control Plane](https://img.shields.io/badge/Stage%202-Control%20Plane-1e293b?style=for-the-badge)
![Workers](https://img.shields.io/badge/Stage%203-Worker%20Join-334155?style=for-the-badge)
![Site](https://img.shields.io/badge/Entry-site.yml-475569?style=for-the-badge)

</div>

---

## Objective

Define a reliable playbook sequence to convert raw EC2 instances into active Kubernetes clusters.

---

## Files

- `site.yml` - orchestrates all stages in order
- `bootstrap.yml` - OS and Kubernetes prerequisites on all nodes
- `control_plane.yml` - `kubeadm init`, kubeconfig setup, Flannel install, join token creation
- `workers.yml` - resolves matching control plane and joins workers

---

## Execution Flow

1. `bootstrap.yml`
- Disables swap
- Configures kernel modules/sysctl
- Installs containerd, kubeadm, kubelet, kubectl

2. `control_plane.yml`
- Initializes control plane per cluster
- Installs Flannel CNI
- Saves worker join command as host fact

3. `workers.yml`
- Maps worker to its cluster group
- Executes cluster-specific join command

---

## Run

```bash
cd ansible
ansible-playbook -i inventory/aws_ec2.yml playbooks/site.yml
```

Or:

```bash
./run-site.sh
```

---

## Final Status

- Ordered orchestration: ENABLED
- Cluster-specific join logic: ENABLED
- Idempotent rerun behavior (core tasks): SUPPORTED
