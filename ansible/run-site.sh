#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
ANSIBLE_LOCAL_TEMP=./.ansible/tmp PYTHONPATH=./pydeps ansible-playbook -i inventory/aws_ec2.yml playbooks/site.yml
