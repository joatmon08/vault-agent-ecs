# vault-agent-ecs

A Docker container to run Vault agent on Amazon ECS


It sets up an opinionated configuration in `agent.hcl` to use
the AWS IAM authentication method for Vault.

| Environment Variable | Description |
| --- | --- |
| `AWS_IAM_ROLE` | Name of the Vault role for the IAM auth method |
| `CONFIG_FILE_NAME` | Name of the configuration file you're reading from and writing to. |
| `CONFIG_FILE_TEMPLATE` | Base64 encoded template file that you want Vault agent to render |