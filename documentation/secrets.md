# Secrets inventory

No secret values are stored in this repo. This lists where each one lives.

| Secret | Stored in | Recreate |
|---|---|---|
| Discord webhook token (Proxmox alerts) | `ansible/secrets.yml` (gitignored, on the workstation); Proxmox notification secret `token` | Discord channel → Integrations → Webhooks |
| Root password, both hosts | set in the installer | choose a new one |
| Workstation SSH key `root@DESKTOP-9PQQ6TC` | private key on the workstation (`~/.ssh/avedis`) | public key is in `ansible/inventory.yml` |
| Cloudflare API token (DNS edit, zone `aved.is`) | inside VM 101: Traefik env and Dokploy DNS provider | Cloudflare → API Tokens, "Edit zone DNS" + Zone Read |
| GHCR classic PAT | inside VM 101: Dokploy registry `ghcr` | GitHub → Tokens (classic), `write:packages` |
| Dokploy internals, RustDesk password | inside VM 101 | come back with the VM |

Keep a copy of `ansible/secrets.yml` somewhere other than the workstation, such as a
password manager.
