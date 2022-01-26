# vault-agent-ecs

A Docker container to run Vault agent on Amazon ECS

It sets up an opinionated configuration in `agent.hcl` to use
the AWS IAM authentication method for Vault.

| Environment Variable | Description |
| --- | --- |
| `VAULT_ROLE` | Name of the Vault role configured with the IAM auth method |
| `TARGET_FILE_NAME` | Name of the file you're reading the template and writing the result. |
| `VAULT_AGENT_TEMPLATE` | Base64 encoded template file that you want Vault agent to render |
| `VAULT_AGENT_EXIT_AFTER_AUTH` | Must be `true` or `false`. Defaults to `true`. |

Vault agent will read the template from `/vault-agent` and write the result to the `/config` directory.