FROM vault:1.9.2

RUN mkdir -p /vault-agent
COPY agent.hcl /vault-agent/agent.hcl
COPY entrypoint.sh ./entrypoint.sh

ENTRYPOINT [ "sh", "./entrypoint.sh" ]