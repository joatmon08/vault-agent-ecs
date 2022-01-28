# vault-agent-ecs

A container image to run Vault agent on Amazon ECS.

> **NOTE:** This is not an image supported by HashiCorp.

The container sets up an opinionated configuration in `agent.hcl` to use
the AWS IAM authentication method for Vault.

| Environment Variable | Description |
| --- | --- |
| `VAULT_ROLE` | Name of the Vault role configured with the IAM auth method |
| `TARGET_FILE_NAME` | Name of the file you're reading the template and writing the result. |
| `VAULT_AGENT_TEMPLATE` | Base64 encoded template file that you want Vault agent to render |
| `VAULT_AGENT_EXIT_AFTER_AUTH` | Must be `true` or `false`. Defaults to `true`. |

Vault agent will read the template from `/vault-agent` and write the
result to the `/config` directory.

Use this container image as a sidecar in your Amazon ECS task definition. 
You can use a shared EFS volume mounted at `/config` container path to store
and read the rendered secrets from Vault agent.

For example, the Terraform configuration shows some of the attributes you need
to set for the agent to run as a sidecar in your ECS task definition.

```hcl
resource "aws_ecs_task_definition" "task" {

  ## ommited for clarity
 
  volume {
    name = "vault"

    efs_volume_configuration {
      file_system_id     = var.efs_file_system_id
      transit_encryption = "ENABLED"
      authorization_config {
        iam             = "ENABLED"
        access_point_id = var.efs_access_point_id
      }
    }
  }

  container_definitions = jsonencode(
    [
      
      ## add your container definition, make sure
      ## it depends on the "vault-agent" container
      ## and mounts the "vault" volume as read-only.
    
      {
        name             = "vault-agent"
        image            = "joatmon08/vault-agent-ecs:1.9.2"
        essential        = false
        logConfiguration = var.log_configuration
        mountPoints = [{
          sourceVolume  = "vault"
          containerPath = "/config"
          readOnly      = true
        }]
        cpu         = 0
        volumesFrom = [],
        healthCheck = {
          "command" : [
            "CMD-SHELL",
            "vault agent --help"
          ],
          "interval" : 5,
          "timeout" : 2,
          "retries" : 3
        },
        environment = [
          {
            name  = "VAULT_ADDR"
            value = var.vault_address
          },
          {
            name  = "VAULT_NAMESPACE"
            value = var.vault_namespace
          },
          {
            name  = "VAULT_ROLE"
            value = var.task_role.id
          },
          {
            name  = "TARGET_FILE_NAME"
            value = var.vault_agent_template_file_name
          },
          {
            name  = "VAULT_AGENT_TEMPLATE"
            value = var.vault_agent_template
          },
          {
            name  = "VAULT_AGENT_EXIT_AFTER_AUTH"
            value = tostring(var.vault_agent_exit_after_auth)
          }
        ]
      }
    ]
  )
}
```
