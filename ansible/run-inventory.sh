#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
ANSIBLE_LOCAL_TEMP=./.ansible/tmp PYTHONPATH=./pydeps ansible-inventory -i inventory/aws_ec2.yml --graph
