<div align="center">

# Kubernetes Role Workflow

### Role-based orchestration for bootstrap, control-plane init, and worker join

![Bootstrap](https://img.shields.io/badge/Stage%201-Bootstrap-0f172a?style=for-the-badge)
![Control Plane](https://img.shields.io/badge/Stage%202-Control%20Plane-1e293b?style=for-the-badge)
![Workers](https://img.shields.io/badge/Stage%203-Worker%20Join-334155?style=for-the-badge)
![Site](https://img.shields.io/badge/Entry-site.yml-475569?style=for-the-badge)

</div>

---

## Objective

Define a reliable role-based sequence to convert raw EC2 instances into active Kubernetes clusters.

---

## Files

- `precheck.yml` - validates env/key/inventory/SSH and required group counts before apply
- `site.yml` - orchestrates all stages in order
- `../roles/bootstrap/tasks/main.yml` - OS and Kubernetes prerequisites on all nodes
- `../roles/bootstrap/handlers/main.yml` - containerd restart handler
- `../roles/control_plane/tasks/main.yml` - `kubeadm init`, kubeconfig setup, Flannel install, join token creation
- `../roles/workers/tasks/main.yml` - resolves matching control plane and joins workers

---

## Execution Flow

0. `precheck.yml`
- Verifies prerequisites before any cluster mutation.

1. `bootstrap` role
- Disables swap
- Configures kernel modules/sysctl
- Installs containerd, kubeadm, kubelet, kubectl

2. `control_plane` role
- Initializes control plane per cluster
- Installs Flannel CNI
- Saves worker join command as host fact

3. `workers` role
- Maps worker to its cluster group
- Executes cluster-specific join command

---

## Run

```bash
cd ansible
ansible-playbook -i inventory/aws_ec2.yml playbooks/precheck.yml
ansible-playbook -i inventory/aws_ec2.yml playbooks/site.yml
```

Or:

```bash
./run-precheck.sh
./run-site.sh
```

---

## Final Status

- Ordered orchestration: ENABLED
- Cluster-specific join logic: ENABLED
- Idempotent rerun behavior (core tasks): SUPPORTED
