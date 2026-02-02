# Networking

This document explains how services communicate and how external access is managed.

- The compose stack creates a dedicated bridge network named `server-net` so containers can reach each other by service name.
- Public services should be routed through `nginx-proxy-manager` (ports 80/443 on the host). Do not expose application ports directly to the Internet unless necessary.
- The `gluetun` container runs the VPN client and when a service uses `network_mode: "service:gluetun"` it will have its traffic routed through the VPN container.

Port mapping notes:
- Be careful about exposing containers on the host: only map ports you intend to reach from the LAN or WAN.

Firewall and LAN:
- Keep the host firewall configured to allow only required ports (80/443 and any admin ports you need) and block unused ones.

DNS and hostnames:
- For local-only access, add host entries or use your local DNS to point service hostnames to the machine IP. For internet access, configure DNS records and use `nginx-proxy-manager` to provision TLS certificates.
