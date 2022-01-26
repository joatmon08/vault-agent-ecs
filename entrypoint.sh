#!/bin/bash

mkdir -p /config

if [[ -z "${VAULT_AGENT_EXIT_AFTER_AUTH}" ]]; then
  EXIT_AFTER_AUTH="true"
else
  EXIT_AFTER_AUTH=${VAULT_AGENT_EXIT_AFTER_AUTH}
fi

sed -i "s~VAULT_ROLE~${VAULT_ROLE}~g" /vault-agent/agent.hcl
sed -i "s~TARGET_FILE_NAME~${TARGET_FILE_NAME}~g" /vault-agent/agent.hcl

sed -i "s~VAULT_AGENT_EXIT_AFTER_AUTH~${EXIT_AFTER_AUTH}~g" /vault-agent/agent.hcl
echo ${VAULT_AGENT_TEMPLATE} | base64 -d > /vault-agent/${TARGET_FILE_NAME}

vault agent -config /vault-agent/agent.hcl