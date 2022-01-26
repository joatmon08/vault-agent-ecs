exit_after_auth = VAULT_AGENT_EXIT_AFTER_AUTH
pid_file        = "./pidfile"

auto_auth {
  method "aws" {
    mount_path = "auth/aws"
    config = {
      type = "iam"
      role = "VAULT_ROLE"
    }
  }

  sink "file" {
    config = {
      path = "/tmp/token"
    }
  }
}

listener "tcp" {
  address = "0.0.0.0:8200"
  tls_disable = true
}

template {
  source      = "/vault-agent/TARGET_FILE_NAME"
  destination = "/config/TARGET_FILE_NAME"
}