## Architecture Overview

- All services run inside a custom Docker bridge network (`server-net`)
- Nginx Proxy Manager provides domain-based routing and TLS termination
- Background-heavy workloads (e.g. Immich ML) coexist with latency-sensitive
  services (e.g. Minecraft) via isolation and resource limits
