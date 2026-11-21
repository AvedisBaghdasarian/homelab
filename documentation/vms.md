# VMs (reference only)

These VMs are restored from backups, not rebuilt
([backups-and-recovery.md](backups-and-recovery.md)).

| VMID | Name | Node | vCPU / RAM | Disk | IP (DHCP) | Role |
|---|---|---|---|---|---|---|
| 101 | docker-pve1 | pve1 | 3 / 6 GB (balloon min 3 GB) | 32 GB `local-lvm` | .118 | Dokploy (swarm manager), Traefik, RustDesk server |
| 102 | gui-pve1 | pve1 | 2 / 3 GB | 40 GB `local-lvm` | .89 | Ubuntu desktop + RustDesk client |
| 201 | docker-pve2 | pve2 | 3 / 6 GB (balloon min 3 GB) | 32 GB `local-lvm` | .220 | Docker Swarm worker |

All three run Ubuntu 24.04 cloud images. Their host-side dependencies are the `hdd` storage,
the cloud-init snippets and `libgl1` (for 102's virtio-gl display). Ansible provides all three.

## Dokploy (on VM 101)

- Panel: **https://dokploy.aved.is** on the LAN, or **http://192.168.50.118:3000**. It runs a
  swarm with docker-pve2 as a worker and uses GHCR as its registry.
- **Dokploy has no backups of its own configured.** It's only covered by VM 101's vzdump
  ([known-issues.md](known-issues.md)).
- HTTPS uses Let's Encrypt with Cloudflare DNS-01. That depends on two settings outside
  Dokploy's database: the resolver block in `/etc/dokploy/traefik/traefik.yml`
  ([files/dokploy/traefik-certresolver.yml](files/dokploy/traefik-certresolver.yml)) and
  `CF_DNS_API_TOKEN` in Traefik's environment. If you restore Dokploy onto a fresh install,
  re-apply both, then run `docker restart dokploy-traefik`.
- The router's local DNS record `dokploy.aved.is → 192.168.50.118` is needed for LAN HTTPS.

## RustDesk server (on VM 101)

Runs from this repo (`stacks/rustdesk`, cloned at `/home/ubuntu/homelab`) with
`docker compose`, not through Dokploy.
