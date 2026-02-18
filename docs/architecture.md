# Architecture Overview

All services run as Docker containers on a single host, connected via a dedicated bridge network (`server-net`).

## Access Model

```
Tailscale device → amanserver.duckdns.org (resolves to Tailscale IP)
  → Nginx Proxy Manager (ports 80/443)
    → subdomain routing to individual services
      e.g. jellyfin.amanserver.duckdns.org → jellyfin:8096
```

- **Tailscale** provides a zero-trust WireGuard mesh — only authenticated devices can reach the server
- **DuckDNS** provides a free domain pointing to the Tailscale IP
- **Nginx Proxy Manager** handles subdomain routing and TLS termination with a wildcard Let's Encrypt certificate (DNS-01 challenge via DuckDNS)

## Service Groups

| Group                | Services                                | Purpose                                 |
| -------------------- | --------------------------------------- | --------------------------------------- |
| **Reverse Proxy**    | Nginx Proxy Manager                     | Subdomain routing, TLS termination      |
| **DNS**              | DuckDNS updater                         | Keeps domain pointing to Tailscale IP   |
| **Media Indexing**   | Sonarr, Radarr, Prowlarr, Bazarr        | Automated media management              |
| **Media Server**     | Jellyfin, Jellyseerr                    | Streaming and media requests            |
| **Downloads**        | qBittorrent, FlareSolverr               | Torrent client and CAPTCHA solver       |
| **Photo Management** | Immich (server + ML + Redis + Postgres) | Self-hosted Google Photos alternative   |
| **VPN**              | Gluetun (ProtonVPN)                     | Routes Jellyseerr traffic through VPN   |
| **Monitoring**       | Portainer, Netdata, Uptime Kuma         | Container management and monitoring     |
| **Utilities**        | Watchtower, Healthcheck Pinger          | Auto-updates and external health checks |
| **Gaming**           | Minecraft                               | Minecraft server with auto-pause        |
| **Dashboard**        | Homepage                                | Service dashboard                       |

## Storage

- Host-mounted directories under `/server/data/` for service configs
- Named volume `model-cache` for Immich ML models
- See [storage.md](storage.md) for details

## Security

- No service ports are exposed to the host except NPM (80/443/81), torrent (6881), Minecraft (25565), and Jellyfin discovery (UDP)
- All HTTP services are accessed through NPM with HTTPS
- Credentials are managed via env files (not committed to repo)
- Access restricted to Tailscale network — public internet cannot reach the Tailscale IP
