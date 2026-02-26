#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

if [ -z "${ANSIBLE_PRIVATE_KEY_FILE:-}" ]; then
  echo "Set ANSIBLE_PRIVATE_KEY_FILE before running run-site.sh"
  exit 1
fi

if [ ! -r "${ANSIBLE_PRIVATE_KEY_FILE}" ]; then
  echo "Cannot read ANSIBLE_PRIVATE_KEY_FILE: ${ANSIBLE_PRIVATE_KEY_FILE}"
  exit 1
fi

ANSIBLE_LOCAL_TEMP=./.ansible/tmp ansible-playbook -i inventory/aws_ec2.yml playbooks/site.yml
