<div align="center">

<h1>KubeCoin Infrastructure Stack</h1>

<p><strong>AWS infrastructure + Ansible automation for dual Kubernetes clusters</strong></p>

![Terraform](https://img.shields.io/badge/Terraform-AWS%20Provisioning-0ea5e9?style=for-the-badge)
![Ansible](https://img.shields.io/badge/Ansible-Cluster%20Bootstrap-2563eb?style=for-the-badge)
![Kubernetes](https://img.shields.io/badge/Kubernetes-Dev%2FTest%20%2B%20Prod-1d4ed8?style=for-the-badge)
![AWS](https://img.shields.io/badge/AWS-EC2%20%2B%20VPC-4338ca?style=for-the-badge)

</div>

---

## Mission

Provision cloud infrastructure and bootstrap two Kubernetes clusters:

- Dev/Test cluster: 1 control plane + 2 workers
- Production cluster: 1 control plane + 2 workers

## Repository Layout

| Path | Purpose |
|---|---|
| `infra/` | Terraform for VPC, networking, EC2, outputs |
| `ansible/` | Inventory, playbooks, and roles for kubeadm setup |

## End-to-End Run Order

```bash
cd infra
terraform init
terraform apply

cd ../ansible
ansible-galaxy collection install -r requirements.yml
./run-precheck.sh
./run-site.sh
```

## Validation

```bash
cd ansible
./run-inventory.sh
ansible-inventory -i inventory/aws_ec2.yml --graph
```

## Documentation Index

- `infra/README.md`
- `ansible/README.md`
- `ansible/playbooks/README.md`
- `ansible/inventory/README.md`

## CI/CD Note

- Jenkins pipelines build and push Docker images using the Jenkins credential `docker-creds`.
- Helm image values are updated from CI and pushed back to Git using `git-creds`.
- Image updates target `kubecoin-helm-charts/kubecoin/values.yaml`.
