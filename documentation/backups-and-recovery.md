# Backups and recovery

## What is backed up

| What | How | Where |
|---|---|---|
| VMs on pve1 (101, 102) | vzdump, nightly 02:30 | pve2's HDD (NFS storage `backup-on-pve2`) |
| VMs on pve2 (201) | vzdump, nightly 03:30 | pve1's HDD (NFS storage `backup-on-pve1`) |
| Host configuration | not backed up; rebuilt from [`ansible/`](../ansible/) | git |

Backups are full zstd archives (`.vma.zst`), taken live in snapshot mode. Retention is 7
daily plus 4 weekly. Files sit in `/mnt/pve/hdd/xbackup/dump/` on the node that *holds*
them. Failures go to Discord. All of this is set up by Ansible.

## Restore a VM

```bash
# both nodes up: through the storage
qmrestore backup-on-pve2:backup/vzdump-qemu-101-<date>.vma.zst 101 --storage local-lvm
# node rebuilt or NFS down: straight from the file on the local HDD
qmrestore /mnt/pve/hdd/xbackup/dump/vzdump-qemu-101-<date>.vma.zst 101 --storage local-lvm
```

Run Ansible before restoring. VMs 101 and 102 won't start without the `hdd` storage and
their cloud-init snippets, and Ansible provides both. Restored VMs keep their MAC addresses,
so router DHCP reservations still apply.

## Losing a node

- **Quorum:** this is a two-node cluster with no QDevice, so the surviving node loses quorum
  and won't start or restore VMs. On the survivor, run `pvecm expected 1`.
- **The dead node's backups are on the survivor's HDD.** Restore from the file path, as
  above. One node (8 GB RAM) can't comfortably run all three VMs, so restore docker-pve1
  first.
- **Rebuild the dead node:** on the survivor run `pvecm delnode <name>`, reinstall the dead
  node ([proxmox-hosts.md](proxmox-hosts.md)), then run Ansible, which rejoins it to the
  cluster.

## Losing both nodes

There's **no off-site copy**, so losing both nodes loses the backups too. See
[known-issues.md](known-issues.md).
