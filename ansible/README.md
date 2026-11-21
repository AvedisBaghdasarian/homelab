# Proxmox host configuration

Takes two freshly installed Proxmox nodes (installer values in
[documentation/proxmox-hosts.md](../documentation/proxmox-hosts.md)) to the full lab
config. Idempotent, so it's safe to re-run.

```bash
uv tool install ansible-core           # or pipx; needs a UTF-8 locale (LC_ALL=C.UTF-8 on WSL)
ssh-copy-id root@192.168.50.200
ssh-copy-id root@192.168.50.201
cp secrets.example.yml secrets.yml     # gitignored
ansible-playbook site.yml --check --diff   # see what would change
ansible-playbook site.yml
```

Per-node settings live in [inventory.yml](inventory.yml).

## Notes

- **The HDD is never formatted by this playbook.** It's mounted by filesystem UUID, so a
  reinstall keeps the backups on it. For a *replacement* disk, partition and format it
  first, then put the new UUID in `inventory.yml`:
  `sgdisk -n1 /dev/sdX && mkfs.ext4 /dev/sdX1 && blkid /dev/sdX1`
- **Cluster join** (`tasks/cluster.yml`) has only been run in check mode, against nodes that
  were already clustered. It hasn't been tested on a fresh install.
- **Secrets:** only the Discord webhook token, kept in `secrets.yml`.
