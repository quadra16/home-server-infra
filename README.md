# Home Server Infrastructure

Self-hosted media, photo management, and monitoring stack — secured behind [Tailscale](https://tailscale.com) with HTTPS via [Nginx Proxy Manager](https://nginxproxymanager.com) and a free [DuckDNS](https://www.duckdns.org) domain.

## Services

| Service         | Description                        | Subdomain        |
| --------------- | ---------------------------------- | ---------------- |
| **Jellyfin**    | Media streaming server             | `jellyfin.*`     |
| **Sonarr**      | TV show management                 | `sonarr.*`       |
| **Radarr**      | Movie management                   | `radarr.*`       |
| **Bazarr**      | Subtitle management                | `bazarr.*`       |
| **Prowlarr**    | Indexer manager                    | `prowlarr.*`     |
| **qBittorrent** | Torrent client                     | `qbit.*`         |
| **Jellyseerr**  | Media request management (via VPN) | `jellyseerr.*`   |
| **Immich**      | Self-hosted photo management       | `immich.*`       |
| **Portainer**   | Docker container management        | `portainer.*`    |
| **Uptime Kuma** | Service uptime monitoring          | `uptime.*`       |
| **Netdata**     | System performance monitoring      | `netdata.*`      |
| **Homepage**    | Service dashboard                  | `home.*`         |
| **Minecraft**   | Game server with auto-pause        | Direct: `:25565` |

## Architecture

```
Tailscale device
  → *.yourdomain.duckdns.org (resolves to Tailscale IP)
    → Nginx Proxy Manager (TLS termination + subdomain routing)
      → Docker containers on server-net bridge network
```

- **Zero-trust access** — only Tailscale-authenticated devices can reach the server
- **Wildcard HTTPS** — Let's Encrypt certificate via DNS-01 challenge
- **No exposed ports** — all HTTP services are behind NPM; only torrent, Minecraft, and discovery ports are mapped to host

## Quick Start

1. **Install Tailscale** on the host and all client devices

2. **Set up DuckDNS:**
   - Create a free domain at [duckdns.org](https://www.duckdns.org)
   - Point it to your Tailscale IP (`tailscale ip -4`)

3. **Configure env files:**

   ```bash
   cp env/duckdns.env.example env/duckdns.env     # DuckDNS token + subdomain
   cp env/immich.env.example env/immich.env         # Immich DB credentials
   cp env/protonvpn.env.example env/protonvpn.env   # VPN credentials
   cp env/common.env.example env/common.env         # Healthcheck URL (optional)
   ```

4. **Start the stack:**

   ```bash
   docker compose up -d
   ```

5. **Configure NPM** at `http://<tailscale-ip>:81`:
   - Add a wildcard SSL certificate (`*.yourdomain.duckdns.org`) using DuckDNS DNS challenge
   - Add proxy hosts for each service (see [docs/networking.md](docs/networking.md) for the full table)

## Directory Structure

```
├── docker-compose.yml          # Full stack definition
├── env/
│   ├── common.env.example      # Timezone, PUID/PGID, healthcheck URL
│   ├── duckdns.env.example     # DuckDNS token and subdomain
│   ├── immich.env.example      # Immich database credentials
│   └── protonvpn.env.example   # VPN credentials for gluetun
└── docs/
    ├── architecture.md         # Service groups and access model
    ├── networking.md           # Subdomain routing and port mapping
    └── storage.md              # Volumes and backup guidance
```

## Updating

Images are automatically updated daily by **Watchtower**. To manually update:

```bash
docker compose pull && docker compose up -d && docker image prune -f
```

## Security

- No credentials are committed — secrets are managed via `env/*.env` files (excluded by `.gitignore`)
- All HTTP traffic is encrypted with TLS via NPM
- Services are only accessible through the Tailscale network
- DuckDNS domain resolves to a Tailscale IP — unreachable from the public internet

## Docs

- [Architecture Overview](docs/architecture.md)
- [Networking & Routing](docs/networking.md)
- [Storage & Backups](docs/storage.md)
