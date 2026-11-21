# Homelab documentation

How to recreate the lab from bare metal. Proxmox is a **standard USB install plus
[Ansible](../ansible/)**, VMs come back from backups, and Dokploy from its own backups.
Anything Ansible configures is documented by the code, not here.

The repo is **public**, so no secrets are stored in it ([secrets.md](secrets.md)).

| Doc | Covers |
|---|---|
| [proxmox-hosts.md](proxmox-hosts.md) | Installer values, then the Ansible run |
| [backups-and-recovery.md](backups-and-recovery.md) | Restoring VMs, losing a node |
| [network.md](network.md) | IP plan, router/DNS, CGNAT, Cloudflare |
| [vms.md](vms.md) | What VMs exist (reference) |
| [secrets.md](secrets.md) | Credentials: where they live, how to recreate them |
| [known-issues.md](known-issues.md) | Open problems and TODOs |

## Rebuild order

1. Install Proxmox on both nodes from USB ([proxmox-hosts.md](proxmox-hosts.md))
2. `ansible-playbook site.yml` ([ansible/README.md](../ansible/README.md))
3. Restore VMs from `/mnt/pve/hdd/xbackup/dump/` ([backups-and-recovery.md](backups-and-recovery.md))
4. Check the router's DHCP reservations and local DNS record ([network.md](network.md))

## Layout

```
pve1 192.168.50.200                       pve2 192.168.50.201
├─ VM 101 docker-pve1 .118  Dokploy        └─ VM 201 docker-pve2 .220  swarm worker
└─ VM 102 gui-pve1    .89   desktop
cluster "avedlab" · nightly backups: pve1 VMs → pve2 HDD, pve2 VMs → pve1 HDD
```

Out of scope: avedis-lab (192.168.50.219), a separate Ubuntu machine.
