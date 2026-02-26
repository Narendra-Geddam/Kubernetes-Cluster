<div align="center">

# Ansible Commands And Issues Log

### Role migration and reapply execution record

![Ansible](https://img.shields.io/badge/Ansible-Execution%20Log-0f172a?style=for-the-badge)
![Roles](https://img.shields.io/badge/Refactor-Playbooks%20to%20Roles-1e293b?style=for-the-badge)
![Inventory](https://img.shields.io/badge/Inventory-aws_ec2-334155?style=for-the-badge)
![Status](https://img.shields.io/badge/Apply-Blocked%20by%20SSH%20Key-475569?style=for-the-badge)

</div>

---

## Commands Executed

```bash
# Syntax checks and role path fix
cd ansible
ansible-playbook -i localhost, playbooks/site.yml --syntax-check
# (failed: role 'bootstrap' not found)

# Updated ansible.cfg with:
# roles_path = ./roles

ansible-playbook -i localhost, playbooks/site.yml --syntax-check

# Collection/dependency checks
ansible-galaxy collection install -r requirements.yml -p collections
./run-inventory.sh
# (failed: boto3/botocore missing after pydeps cleanup)

python3 -m pip install --user boto3 botocore
./run-inventory.sh
# (failed in non-elevated mode: could not connect to AWS endpoint)

./run-inventory.sh
# (rerun with elevated/network-enabled execution: success)

# Apply role-based cluster setup
./run-site.sh
# (run with elevated/network-enabled execution)
```

---

## Issues Faced

1. Roles not discovered initially
- Error: `the role 'bootstrap' was not found`
- Resolution: added `roles_path = ./roles` to `ansible.cfg`.

2. Missing Python AWS SDK dependencies
- Error: inventory plugin failed due missing `boto3`/`botocore`.
- Resolution: installed with `python3 -m pip install --user boto3 botocore`.

3. Dynamic inventory endpoint connectivity (non-elevated run)
- Error: `Could not connect to the endpoint URL: https://ec2.eu-north-1.amazonaws.com/`
- Resolution: reran inventory/apply in elevated mode with network access.

4. SSH access denied on all nodes during apply
- Error: `Permission denied (publickey,gssapi-keyex,gssapi-with-mic)`
- Root cause: matching private key file for EC2 key pair (`Ansible`) is not configured locally.
- Required fix:
  - place the correct private key on this machine,
  - export `ANSIBLE_PRIVATE_KEY_FILE=/absolute/path/to/Ansible.pem`,
  - rerun `./run-site.sh`.

---

## Final Outcome

- Ansible refactor to roles: complete.
- Dynamic inventory: working.
- Full cluster configuration apply: blocked only by missing SSH private key.
