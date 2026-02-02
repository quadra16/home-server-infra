# Home Server Infrastructure

Opinionated Docker Compose configuration and helper scripts to run a
home media, photo management, and monitoring stack on a single host.

This repo contains:

- `docker-compose.yml` — the full stack (reverse proxy, media apps, Immich, monitoring, VPN)
- `env/*.example` — example environment files. Copy and edit into `env/*.env` or `.env` before starting.
- `scripts/` — helper scripts: `backup.sh`, `restore.sh`, `update.sh`
- `docs/` — architecture, networking, and storage notes

Quick start

1. Copy and secure env files:

	- Copy `env/common.env.example` to `env/common.env` and set `HEALTHCHECK_URL` if you use an external ping service.
	- Copy `env/immich.env.example` to `env/immich.env` and set strong DB credentials.
	- Copy `env/protonvpn.env.example` to `env/protonvpn.env` if you use ProtonVPN credentials with `gluetun`.

2. Start the stack:

	```bash
	docker compose up -d
	```

3. Inspect status:

	```bash
	docker compose ps
	```

Backups

- Use `./scripts/backup.sh` to create DB dumps and tarballs of configured host paths. Backups are saved under `backups/` within the repo (adjust in the script if you prefer a different location).
- Use `./scripts/restore.sh <backup-folder>` to restore. Test restores in a safe environment before relying on them.

Updating

- Run `./scripts/update.sh` to pull images, recreate the stack, and prune unused images.

Security and secrets

- Do NOT commit real credentials to source control. Keep `env/*.env` files out of the repo or in a secrets manager.
- `docker-compose.yml` was sanitized to remove embedded tokens; healthchecks and other secrets should be provided via env files.

Where to go next

- Read `docs/architecture.md`, `docs/networking.md`, and `docs/storage.md` for operational notes and recommended practices.
