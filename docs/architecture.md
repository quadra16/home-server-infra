## Architecture Overview

- **Network:** All services run inside a dedicated Docker bridge network (`server-net`) to simplify inter-service communication and limit exposure.
- **Edge / Routing:** `nginx-proxy-manager` handles host routing and TLS termination for services exposed to the LAN or internet.
- **Service groups:**
  - Media and indexing (Sonarr, Radarr, Prowlarr, Bazarr, Jellyfin)
  - Photo management (Immich server + ML worker + Postgres + Redis)
  - Utilities & monitoring (Portainer, Netdata, Uptime-Kuma)
  - VPN isolator (gluetun) — used as a service-level network namespace for apps that should route through ProtonVPN

Volumes are used for persistent storage and the `model-cache` named volume holds ML models for the Immich ML worker.

Security notes:
- Sensitive credentials are kept out of `docker-compose.yml` and should be provided via env files under `env/` (see `env/*.env.example`).
- Services that must be reachable externally should be routed via `nginx-proxy-manager` and secured with TLS.
