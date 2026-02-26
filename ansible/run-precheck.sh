#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

if ! command -v ansible-playbook >/dev/null 2>&1; then
  echo "ansible-playbook not found"
  exit 1
fi

if ! command -v ansible-inventory >/dev/null 2>&1; then
  echo "ansible-inventory not found"
  exit 1
fi

if ! python3 -c "import boto3, botocore" >/dev/null 2>&1; then
  echo "Missing boto3/botocore. Install with: python3 -m pip install --user boto3 botocore"
  exit 1
fi

if [ -z "${ANSIBLE_PRIVATE_KEY_FILE:-}" ]; then
  echo "Set ANSIBLE_PRIVATE_KEY_FILE before running precheck"
  exit 1
fi

if [ ! -r "${ANSIBLE_PRIVATE_KEY_FILE}" ]; then
  echo "Cannot read ANSIBLE_PRIVATE_KEY_FILE: ${ANSIBLE_PRIVATE_KEY_FILE}"
  exit 1
fi

ANSIBLE_LOCAL_TEMP=./.ansible/tmp ansible-inventory -i inventory/aws_ec2.yml --graph
ANSIBLE_LOCAL_TEMP=./.ansible/tmp ansible-playbook -i inventory/aws_ec2.yml playbooks/precheck.yml
