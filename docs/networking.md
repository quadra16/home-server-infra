# Networking

## How Services Are Accessed

All services are accessed through **Nginx Proxy Manager** via HTTPS subdomains on a **DuckDNS** domain. The domain resolves to the server's **Tailscale IP**, so only devices on the tailnet can reach them.

```
Client → DNS (*.yourdomain.duckdns.org) → Tailscale IP → NPM → Container
```

## Subdomain Routing

NPM routes traffic based on subdomain. Each service gets its own subdomain with a shared wildcard TLS certificate.

| Subdomain      | Container           | Port  | Protocol |
| -------------- | ------------------- | ----- | -------- |
| `home.*`       | homepage            | 3000  | http     |
| `jellyfin.*`   | jellyfin            | 8096  | http     |
| `sonarr.*`     | sonarr              | 8989  | http     |
| `radarr.*`     | radarr              | 7878  | http     |
| `bazarr.*`     | bazarr              | 6767  | http     |
| `prowlarr.*`   | prowlarr            | 9696  | http     |
| `qbit.*`       | qbittorrent         | 8080  | http     |
| `portainer.*`  | portainer           | 9443  | https    |
| `uptime.*`     | uptime-kuma         | 3001  | http     |
| `netdata.*`    | netdata             | 19999 | http     |
| `immich.*`     | immich-server       | 2283  | http     |
| `jellyseerr.*` | protonvpn (gluetun) | 5055  | http     |

## Docker Network

- All containers connect to a single bridge network named `server-net`
- NPM reaches services by container name (Docker DNS)
- Jellyseerr uses `network_mode: "service:gluetun"` — its traffic exits through ProtonVPN

## Ports Exposed on Host

Only non-HTTP ports are mapped to the host:

| Port               | Service     | Reason                        |
| ------------------ | ----------- | ----------------------------- |
| 80, 443, 81        | NPM         | HTTP/HTTPS routing + admin UI |
| 6881/tcp+udp       | qBittorrent | Torrent peer connections      |
| 25565              | Minecraft   | Game server                   |
| 1900/udp, 7359/udp | Jellyfin    | DLNA and client discovery     |

## DNS Setup

1. Create a free domain at [duckdns.org](https://www.duckdns.org)
2. Point it to your Tailscale IP (`tailscale ip -4`)
3. The `duckdns` container keeps the record updated every 5 minutes

## TLS / SSL

A wildcard certificate (`*.yourdomain.duckdns.org`) is provisioned via Let's Encrypt DNS-01 challenge through NPM. This covers all subdomains automatically.
