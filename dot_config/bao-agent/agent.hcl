# OpenBao Agent for this machine. Runs as a launchd job (Library/LaunchAgents/
# dev.cc-live.bao-agent.plist) from login, and keeps two files fresh so that
# no shell ever needs a secret in its environment:
#
#   ~/.vault-token       the token `bao` and the Terraform vault provider read
#                        by default. Renewed before expiry; re-authenticated
#                        from scratch at max_ttl. Should carry the read-only
#                        `agent-ro` policy -- writes use an OIDC admin token
#                        held only for the duration of a `terraform apply`:
#                          BAO_TOKEN=$(bao login -method=oidc -token-only role=admin) terraform apply
#
#   ~/.aws/credentials   ONE profile, [cc-live-r2]: the Cloudflare R2 keys for
#                        the Terraform state backend, which initialises before
#                        any provider exists and so cannot fetch its own keys.
#                        Every cc-live module's backend names this profile.
#                        The agent owns this whole file.
#
# The AppRole secret half lives at ~/.config/cc-live/agent-secret-id (0600,
# issued once per device by an admin: `bao write -f auth/approle/role/agent/secret-id`).
# Neither this file nor the .ctmpl is a chezmoi template: their {{ }} would collide with chezmoi's.
pid_file = "/Users/chriscrain/.config/bao-agent/agent.pid"

vault {
  address = "https://bao.tail5d7bcc.ts.net"
  retry { num_retries = 12 }   # tailnet may not be up yet at login
}

auto_auth {
  method "approle" {
    config = {
      role_id_file_path                   = "/Users/chriscrain/.config/bao-agent/role-id"
      secret_id_file_path                 = "/Users/chriscrain/.config/cc-live/agent-secret-id"
      remove_secret_id_file_after_reading = false
    }
  }
  sink "file" {
    config = { path = "/Users/chriscrain/.vault-token", mode = 0600 }
  }
}

template {
  # Kept in its own file: agent config is HCL1, and an inline heredoc was
  # silently not registered as a template (the agent then exited with
  # "no env templates or exec config").
  source      = "/Users/chriscrain/.config/bao-agent/aws-credentials.ctmpl"
  destination = "/Users/chriscrain/.aws/credentials"
  perms       = 0600
}
