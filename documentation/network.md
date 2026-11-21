# Network

## LAN — 192.168.50.0/24

| IP | Host | How assigned | Notes |
|---|---|---|---|
| 192.168.50.1 | Router | static | Gateway, DHCP server, DNS for the LAN |
| 192.168.50.200 | **pve1** | static (`/etc/network/interfaces`) | Proxmox node 1 |
| 192.168.50.201 | **pve2** | static | Proxmox node 2 |
| 192.168.50.118 | **docker-pve1** (VM 101) | DHCP | Dokploy + Traefik + RustDesk. **Other config depends on this IP** (swarm manager address, local DNS record, RustDesk clients). |
| 192.168.50.220 | **docker-pve2** (VM 201) | DHCP | Swarm worker |
| 192.168.50.89 | **gui-pve1** (VM 102) | DHCP | Desktop VM |
| 192.168.50.219 | avedis-lab | — | Separate machine, out of scope |

The VMs use DHCP (`ipconfig0: ip=dhcp`). **Make DHCP reservations on the router** for
.118 and .220 at least — if docker-pve1's IP changes, the swarm, the local DNS
record and RustDesk clients all break. (Not verified whether reservations exist —
see [known-issues.md](known-issues.md).) MAC addresses are in each VM's Proxmox config
(`qm config <id> | grep net0`); on a from-scratch rebuild the MACs change, so update the
reservations.

## Local DNS

The router answers LAN DNS. It has a local record:

| Name | → |
|---|---|
| `dokploy.aved.is` | 192.168.50.118 |

This makes LAN clients reach Traefik directly with the real Let's Encrypt certificate
(see [vms.md](vms.md#dokploy-on-vm-101)). A wildcard `*.aved.is → 192.168.50.118` would cover
every future app, if the router supports wildcards. Without a router entry, a hosts-file
line on a client works for testing:
`192.168.50.118 dokploy.aved.is` (Windows: `C:\Windows\System32\drivers\etc\hosts`).

The record does **not** exist in public DNS — the name only resolves on the LAN.

## Internet

- ISP: **T-Mobile**, behind **CGNAT**. No port forwarding is possible; nothing on the
  LAN is reachable from the internet directly.
- Consequences:
  - Let's Encrypt **HTTP-01 cannot work** → we use **DNS-01 via Cloudflare**.
  - Public exposure, if wanted, must go through a **Cloudflare Tunnel** (not set up).
    Dokploy guide: https://docs.dokploy.com/docs/core/guides/cloudflare-tunnels
- Dokploy's auto-generated test domains use `sslip.io` with the public IP; they are
  not reachable from outside because of CGNAT.

## Cloudflare

- Domain **`aved.is`**, DNS hosted on Cloudflare (nameservers `*.ns.cloudflare.com`).
- The apex `aved.is` is proxied and protected by **Cloudflare Access** (Zero Trust
  login). Don't point lab services at the apex; use subdomains.
- API token for DNS-01: see [secrets.md](secrets.md).
- Cloudflare's L4 proxy (Spectrum) for raw TCP/443 is Enterprise-only, so end-to-end
  TLS from the internet would need a VPS or WARP/Tailscale instead. Decision so far:
  LE certs on the LAN via DNS-01; public access (later) via Tunnel with Cloudflare's
  edge cert, origin keeps the LE cert (SSL mode **Full (strict)**).
