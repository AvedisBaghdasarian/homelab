# Known issues / TODO

## Recovery gaps
1. **Two-node cluster with no QDevice.** If one node goes down, the survivor loses quorum,
   and you have to run `pvecm expected 1` before it will start or restore VMs. Fix: run a
   QDevice on a third always-on machine.
2. **No off-site backup.** Every backup lives on the two nodes.
3. **Dokploy has no backups of its own.** It has no S3 destination and no backup jobs, so
   it's covered only by VM 101's vzdump.
4. **The backups aren't PBS yet.** They're plain vzdump to the peer node over NFS: no
   dedup, no verify jobs, and no file-level restore.

## Proxmox
5. **pve1 has more VM memory assigned than it has RAM.** 9 GB is assigned on an 8 GB host,
   so VM 101 runs ballooned to about 2.8 GB and the host swaps.
6. **pve1's thin pool is overcommitted** (72 GiB of virtual disks in 66 GiB, about 25% used),
   and nothing alerts when it fills.
7. **The root@pam email is a placeholder.** The built-in mail target goes nowhere; Discord
   covers errors.
8. **An unused Docker apt repo** (`/etc/apt/sources.list.d/docker.list`) is still on pve1.
   Delete it.
9. **pve2's HDD is believed to be SMR.** That's fine for backups, but don't put VM disks on it.

## Network
10. **The VMs use DHCP, and nobody has confirmed reservations for .118 and .220.**
11. **The router model and where its `dokploy.aved.is → .118` record is set aren't documented.**

## VMs (minor)
12. **VMs 101 and 102 both use the hostname `ubuntu`.** Their cloud-init snippets don't set one.
13. **Coolify leftovers remain on VM 101:** a `coolify` key in root's `authorized_keys` and
    `~ubuntu/coolify-env-backup`.
14. **Dokploy can reset the DNS-01 resolver in `traefik.yml`** when Web Server settings are
    saved. Restart Traefik after editing it.
