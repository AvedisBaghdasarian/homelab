# Proxmox hosts

Two Dell OptiPlex 3050 Micro boxes (i5-7500T, 8 GB RAM, 128 GB NVMe + 1 TB 2.5" HDD),
clustered as `avedlab`. A rebuild is: **standard USB install → run Ansible**. Everything
after the installer is in [`ansible/`](../ansible/), and that code is the documentation for it.

## 1. Installer (Proxmox VE 9.x ISO)

| Wizard field | pve1 | pve2 |
|---|---|---|
| Target disk | NVMe (128 GB), **ext4** (default LVM layout) | same |
| Country / timezone / keyboard | United States / America/Los_Angeles / en-us | same |
| Root password / email | *(choose; email can be anything)* | same |
| Management interface | `nic0` | `nic0` |
| Hostname (FQDN) | `pve1.local` | `pve2.local` |
| IP (CIDR) | `192.168.50.200/24` | `192.168.50.201/24` |
| Gateway | `192.168.50.1` | `192.168.50.1` |
| DNS | `192.168.50.1` | `192.168.50.1` |

- **Don't touch the HDD** during install. It holds the other node's backups, and Ansible
  mounts it as-is.
- If one node is being reinstalled while the other is still running, first remove the old
  member on the survivor: `pvecm delnode <name>`. Ansible then rejoins the new install.

## 2. Configure

```bash
ssh-copy-id root@192.168.50.200      # and .201: Ansible logs in as root with your key
cd ansible && cp secrets.example.yml secrets.yml   # fill in the Discord token
ansible-playbook site.yml
```

See [ansible/README.md](../ansible/README.md) for details. The playbook handles: repos,
packages, the turbo fix, the HDD mount, NFS, cluster create and join, storages, backup jobs,
Discord alerts and cloud-init snippets.

## 3. Then

Restore VMs: [backups-and-recovery.md](backups-and-recovery.md).
